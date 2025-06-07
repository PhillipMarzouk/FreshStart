# food_order_api/management/commands/import_menu_csv.py

import csv
import re
from datetime import datetime
from django.core.management.base import BaseCommand, CommandError
from food_order_api.models import MenuItem, LunchProgram, PlatePortion

class Command(BaseCommand):
    help = "Import menu items from a CSV. Dates may be in YYYY-MM-DD or M/D/YYYY format."

    def add_arguments(self, parser):
        parser.add_argument(
            "--csv-path",
            required=True,
            help="Absolute path to the CSV file containing menu data",
        )
        parser.add_argument(
            "--create-only",
            action="store_true",
            help="If set, only creates new MenuItem rows; skip any that already exist.",
        )
        parser.add_argument(
            "--update-only",
            action="store_true",
            help="If set, only updates MenuItem rows that already exist; skip any new plate_name.",
        )

    def handle(self, *args, **options):
        path = options["csv_path"]
        create_only = options["create_only"]
        update_only = options["update_only"]

        if create_only and update_only:
            raise CommandError("You may not specify both --create-only and --update-only at the same time.")

        try:
            f = open(path, newline="", encoding="utf-8")
        except FileNotFoundError:
            raise CommandError(f"CSV file not found at path: {path!r}")

        reader = csv.DictReader(f)
        line_num = 1
        for row in reader:
            line_num += 1
            plate_name = row.get("plate_name", "").strip()
            meal_type = row.get("meal_type", "").strip()
            date_str = row.get("available_date", "").strip()

            # (1) Parse the date in either YYYY-MM-DD or M/D/YYYY
            available_date = None
            if date_str:
                parsed = False
                for fmt in ("%Y-%m-%d", "%m/%d/%Y"):
                    try:
                        available_date = datetime.strptime(date_str, fmt).date()
                        parsed = True
                        break
                    except ValueError:
                        continue
                if not parsed:
                    self.stdout.write(self.style.WARNING(
                        f"[line {line_num}] Skipping row with invalid date format: {date_str}"
                    ))
                    continue

            # CHANGE: Capture image URL from CSV
            image_url = row.get("image", "").strip()

            # ————————————————
            # CHANGE: Parse lunch_programs early so we can use it in the "exists" check
            lunch_programs_cell = row.get("lunch_programs", "").strip()
            lp_instances = []
            if lunch_programs_cell:
                self.stdout.write(self.style.NOTICE(
                    f"[line {line_num}] RAW lunch_programs cell: '{lunch_programs_cell}'"
                ))
                for name in lunch_programs_cell.split(","):
                    name = name.strip()
                    if not name:
                        continue
                    try:
                        lp = LunchProgram.objects.get(name__iexact=name)
                        lp_instances.append(lp)
                    except LunchProgram.DoesNotExist:
                        self.stdout.write(self.style.WARNING(
                            f"[line {line_num}]   • LunchProgram '{name}' not found—skipping"
                        ))
            else:
                self.stdout.write(self.style.NOTICE(
                    f"[line {line_num}]  → no lunch_programs specified"
                ))

            # Determine which LunchProgram to use for matching uniqueness.
            lp_to_match = lp_instances[0] if lp_instances else None

            # ————————————————
            # CHANGE: Check for existing MenuItem by (plate_name, available_date, lunch_program)
            if lp_to_match:
                existing_qs = MenuItem.objects.filter(
                    plate_name__iexact=plate_name,
                    available_date=available_date,
                    lunch_programs=lp_to_match
                )
            else:
                existing_qs = MenuItem.objects.filter(
                    plate_name__iexact=plate_name,
                    available_date=available_date
                )
            exists = existing_qs.exists()

            # (2) Should we create, update, or skip?
            if update_only and not exists:
                self.stdout.write(self.style.WARNING(
                    f"[line {line_num}] (--update-only) skipping new plate_name: '{plate_name}'"
                ))
                continue

            if create_only and exists:
                self.stdout.write(self.style.NOTICE(
                    f"[line {line_num}] (--create-only) skipping existing plate_name/date/program combo: '{plate_name}'"
                ))
                continue

            if exists:
                menu_item = existing_qs.first()
                created = False
                action = "Updated"
                menu_item.meal_type = meal_type
                menu_item.available_date = available_date
                menu_item.is_field_trip = row.get("is_field_trip", "").strip().lower() in ("1", "true", "yes")
                menu_item.is_new     = row.get("is_new", "").strip().lower() in ("1", "true", "yes")
                # CHANGE: Update image field on existing object
                menu_item.image = image_url
                menu_item.save()
            else:
                menu_item = MenuItem.objects.create(
                    plate_name=plate_name,
                    meal_type=meal_type,
                    is_field_trip=row.get("is_field_trip", "").strip().lower() in ("1", "true", "yes"),
                    is_new=row.get("is_new", "").strip().lower() in ("1", "true", "yes"),
                    available_date=available_date,
                    # CHANGE: Set image on creation
                    image=image_url,
                )
                created = True
                action = "Created"

            # (3) Clear existing M2M links (so CSV becomes the single source of truth)
            menu_item.lunch_programs.clear()
            menu_item.plate_portions.clear()

            # ————————————————
            # (4) Re-attach lunch_programs (all parsed LP instances, not just the one used for matching)
            if lp_instances:
                for lp in lp_instances:
                    menu_item.lunch_programs.add(lp)
                    self.stdout.write(self.style.SUCCESS(
                        f"[line {line_num}]   • attached LunchProgram '{lp.name}' (id={lp.id})"
                    ))
            else:
                pass

            # ————————————————
            # (5) Handle plate_portions (split on comma or pipe)
            portions_cell = row.get("plate_portions", "").strip()
            if portions_cell:
                self.stdout.write(self.style.NOTICE(
                    f"[line {line_num}] RAW plate_portions cell: '{portions_cell}'"
                ))
                parts = re.split(r"[,\|]+", portions_cell)
                for part in parts:
                    name = part.strip()
                    if not name:
                        continue

                    pp = None
                    if name.isdigit():
                        try:
                            pp = PlatePortion.objects.get(pk=int(name))
                            self.stdout.write(self.style.SUCCESS(
                                f"[line {line_num}]   • attached PlatePortion id={name}"
                            ))
                        except PlatePortion.DoesNotExist:
                            pp = None

                    if pp is None:
                        try:
                            pp = PlatePortion.objects.get(name__iexact=name)
                            self.stdout.write(self.style.SUCCESS(
                                f"[line {line_num}]   • attached PlatePortion '{name}' (id={pp.id})"
                            ))
                        except PlatePortion.DoesNotExist:
                            pp = None

                    if pp:
                        menu_item.plate_portions.add(pp)
                    else:
                        self.stdout.write(self.style.WARNING(
                            f"[line {line_num}]   • PlatePortion '{name}' not found—skipping"
                        ))
            else:
                self.stdout.write(self.style.NOTICE(
                    f"[line {line_num}]  → no plate_portions specified"
                ))

            # (6) Finally, report success
            self.stdout.write(self.style.SUCCESS(
                f"[line {line_num}] {action} MenuItem: {menu_item.plate_name} "
                f"(Date: {menu_item.available_date}, ID: {menu_item.id})"
            ))

        f.close()