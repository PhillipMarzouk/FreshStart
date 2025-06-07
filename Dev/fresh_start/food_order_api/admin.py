import os
import pandas as pd
import datetime

from django.db.models import Sum
from django.contrib import admin, messages
from django.http import HttpResponse
from django.utils.safestring import mark_safe
from django.urls import path, reverse
from django.shortcuts import render, redirect
from django.conf import settings
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm
from django import forms
from django.urls import reverse
from django.utils.html import format_html
from utils.sendpulse import SendPulseAPI

from .forms import SchoolAdminForm, OrderItemInlineForm
from .models import (
    MenuItem, PlatePortion, MenuDate, LunchProgram, DeliverySchedule,
    UserOrder, OrderItem, CustomerSupportProfile, UserProfile, School,
    MilkTypeImage, CustomUser, SchoolGroup, DAYS_OF_WEEK
)

from django.template.response import TemplateResponse
from django.core.management import call_command



class SuperuserOnlyAdmin(admin.ModelAdmin):
    def has_module_permission(self, request):
        return request.user.is_superuser

    def get_model_perms(self, request):
        if request.user.is_superuser:
            return super().get_model_perms(request)
        return {}

# ✅ Register models safely to prevent duplication
for model in [LunchProgram, PlatePortion, MenuDate, DeliverySchedule]:
    if not admin.site.is_registered(model):
        admin.site.register(model, SuperuserOnlyAdmin)

# ✅ Menu Item Admin
class MenuItemForm(forms.ModelForm):
    available_date = forms.DateField(widget=forms.DateInput(attrs={'type': 'date'}))
    class Meta:
        model = MenuItem
        fields = '__all__'

class MenuItemAdmin(admin.ModelAdmin):
    form = MenuItemForm
    list_display = ("menu_item_actions", "meal_type", "total_ordered_count", "available_date", "is_new")
    search_fields = ("plate_name", "meal_type")
    list_filter = ("meal_type", "is_new", "available_date")
    ordering = ("plate_name",)
    readonly_fields = ("image_preview",)
    filter_horizontal = ("lunch_programs", "plate_portions")

    change_list_template = "admin/food_order_api/menuitem/change_list.html"

    # ----------------------------------------------------------
    #         Add a custom URL for the CSV‐upload view
    # ----------------------------------------------------------
    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path(
                "upload-csv/",
                self.admin_site.admin_view(self.upload_csv),
                name="food_order_api_menuitem_upload_csv",
            ),
        ]
        return custom_urls + urls

    # ----------------------------------------------------------
    #         This view handles the POST from our modal.
    #         On success, it calls the import_menu_csv management command
    # ----------------------------------------------------------
    def upload_csv(self, request):
        """
        Endpoint: /admin/food_order_api/menuitem/upload-csv/
        Accepts a POST with a single 'csv_file' (from the modal form).
        Saves it temporarily, calls the 'import_menu_csv' command,
        and redirects back to the changelist with a success/error message.
        """
        if request.method == "POST":
            csv_file = request.FILES.get("csv_file", None)
            if not csv_file:
                messages.error(request, "No file was uploaded.")
                return redirect(request.path.replace("upload-csv/", ""))

            # Save the uploaded file to a temporary location
            temp_folder = os.path.join(settings.BASE_DIR, "tmp_csv_uploads")
            os.makedirs(temp_folder, exist_ok=True)
            temp_path = os.path.join(temp_folder, csv_file.name)

            with open(temp_path, "wb+") as dest:
                for chunk in csv_file.chunks():
                    dest.write(chunk)

            # Call the import_menu_csv command, passing the --csv-path argument
            try:
                call_command("import_menu_csv", csv_path=temp_path)
                messages.success(request, f"Successfully imported '{csv_file.name}'.")
            except Exception as e:
                messages.error(request, f"Error importing '{csv_file.name}': {e}")

            # Redirect back to the MenuItem changelist
            return redirect(request.path.replace("upload-csv/", ""))

        # If somehow accessed with GET, just redirect to changelist
        return redirect(request.path.replace("upload-csv/", ""))

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="100" height="100" style="border-radius: 10px;" />', obj.image.url)
        return "(No image uploaded)"

    def menu_item_actions(self, obj):
        edit_url = reverse("admin:food_order_api_menuitem_change", args=[obj.id])
        delete_url = reverse("admin:food_order_api_menuitem_delete", args=[obj.id])
        clone_url = reverse("menu_item_clone", args=[obj.id])
        return format_html(
            """
            <strong style="font-size: 18px;"><a href="{}">{}</a></strong><br>
            <span style="font-size: 13px; font-weight: 300;">
                <a href='{}' style="padding-right: 10px;">Edit</a>
                <a href='{}' style="color: #dc3545; padding-right: 10px;">Trash</a>
                <a href='{}'>Clone</a>
            </span>
            """, edit_url, obj.plate_name, edit_url, delete_url, clone_url
        )

    menu_item_actions.short_description = "Menu Item"

    def get_queryset(self, request):
        return super().get_queryset(request).annotate(total_quantity=Sum("orderitem__quantity"))

    def total_ordered_count(self, obj):
        return obj.total_quantity or 0

    total_ordered_count.admin_order_field = "total_quantity"
    total_ordered_count.short_description = "Total Ordered"

admin.site.register(MenuItem, MenuItemAdmin)

@admin.register(SchoolGroup)
class SchoolGroupAdmin(admin.ModelAdmin):
    list_display = ("name",)
    search_fields = ("name",)

# ✅ School Admin
class SchoolAdmin(admin.ModelAdmin):
    form = SchoolAdminForm

    def display_lunch_programs(self, obj):
        return ", ".join([p.name for p in obj.lunch_programs.all()]) if obj.lunch_programs.exists() else "—"

    def display_delivery_schedule(self, obj):
        return ", ".join([d.name for d in obj.delivery_schedule.all()]) if obj.delivery_schedule.exists() else "—"

    display_lunch_programs.short_description = "Lunch Programs"
    display_delivery_schedule.short_description = "Delivery Schedule"

    list_display = (
        "name", "group", "display_lunch_programs", "display_delivery_schedule",
        "route_number", "grade_level", "delivery_type"
    )
    search_fields = ("name",)
    filter_horizontal = ("lunch_programs", "delivery_schedule")
    autocomplete_fields = ["users"]

    fieldsets = (
        (None, {
            "fields": (
                "name", "group", "users", "route_number", "grade_level", "delivery_type",
                "lunch_programs", "delivery_schedule"
            )
        }),
        ("Pizza Days", {"fields": ("pizza_days",)}),
        ("Family Style Days", {"fields": ("family_style_days",)}),
        ("Milk Distribution", {
            "classes": ("collapse",),
            "fields": (
                "breakfast_milk_distribution", "cereal_milk_distribution",
                "lunch_milk_distribution", "snack_milk_distribution", "therapeutic_milk_distribution",
            )
        }),
    )

    class Media:
        css = {'all': ('css/admin_custom.css',)}




# ✅ Order Admin
class OrderItemInline(admin.TabularInline):
    model = OrderItem
    form = OrderItemInlineForm
    extra = 1
    fields = ["menu_item", "quantity", "menu_item_date", "delivery_date"]


def get_container_type(meal_type, date, school):
    family_style_eligible = {
        "Hot Meal", "Hot Vegetarian", "Cold Meal", "Cold Vegetarian", "Cold Pastas", "Daily Salad"
    }
    always_prepacked = {
        "Breakfast", "Breakfast Cereal", "Milk", "Snack", "Vegan", "Therapeutic"
    }

    if meal_type in always_prepacked:
        return "Pre-Packed"

    weekday_key = date.strftime("%a").lower()[:3]
    if meal_type in family_style_eligible and weekday_key in school.family_style_days:
        return "Family Style"

    return "Pre-Packed"

class UserOrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "status", "created_at", "notes", "staff_notes")
    list_filter = ("status", "created_at")
    search_fields = ("user__username", "id")
    inlines = [OrderItemInline]
    readonly_fields = ["created_at"]
    exclude = ("menu_items",)
    fields = ("user", "status", "school", "notes", "staff_notes", "created_at")

    class Media:
        js = ('admin/js/export_production.js',)

    def get_urls(self):
        urls = super().get_urls()
        return [path("export-excel/", self.admin_site.admin_view(self.export_production_excel), name="export_production_excel")] + urls

    def export_production_excel(self, request):
        selected_date = request.GET.get("date")
        if not selected_date:
            return HttpResponse("Please select a valid date.", status=400)

        try:
            delivery_date = datetime.datetime.strptime(selected_date, "%Y-%m-%d").date()
        except ValueError:
            return HttpResponse("Invalid date format.", status=400)

        order_items = OrderItem.objects.filter(delivery_date=delivery_date)
        data = []

        pizza_tracker = set()
        for item in order_items:
            user = item.order.user
            profile = getattr(user, "profile", None)
            csr_rep = str(profile.support_rep) if profile and profile.support_rep else "N/A"
            school = item.order.school

            # ✅ Add Pizza for this school if applicable
            weekday_key = item.menu_item_date.strftime("%a").lower()[:3]
            pizza_key = (school.id, item.menu_item_date)

            if hasattr(school, "pizza_days") and weekday_key in school.pizza_days and pizza_key not in pizza_tracker:
                data.append([
                    "", item.delivery_date, item.menu_item_date, "Pizza", "N/A", "",
                    school.route_number if school else "NO ROUTE",
                    school.name if school else "NO SCHOOL",
                    school.grade_level if school else "—", "", 0,
                    "Pizza", "Pre-Packed", "",
                    school.delivery_type if school else "NO DELIVERY", "", ""
                ])
                pizza_tracker.add(pizza_key)


            # ✅ Add the actual menu item
            data.append([
                "", item.delivery_date, item.menu_item_date, item.menu_item.meal_type, csr_rep, "",
                school.route_number if school else "NO ROUTE",
                school.name if school else "NO SCHOOL",
                school.grade_level if school else "—", "", item.quantity,
                item.menu_item.plate_name,
                get_container_type(item.menu_item.meal_type, item.menu_item_date, school),
                "", school.delivery_type if school else "NO DELIVERY", "", ""
            ])


        df = pd.DataFrame(data, columns=[
            "", "Delivery Date", "Consumption Date", "Type", "CSR REP", "Time", "Route Number", "School Name",
            "Grade", "Production Notes", "Count", "Menu", "Containers", "V no.", "Delivery Type", "Student Name", "Remarks"
        ])

        export_dir = "/home/FreshStart/exports"
        os.makedirs(export_dir, exist_ok=True)
        file_name = f"FINAL PRODUCTION {delivery_date.strftime('%B %d, %Y')}.xlsx"
        file_path = os.path.join(export_dir, file_name)

        with pd.ExcelWriter(file_path, engine="xlsxwriter") as output:
            df.to_excel(output, index=False, sheet_name="Production Sheet", startrow=3)
            worksheet = output.sheets["Production Sheet"]
            worksheet.set_row(0, 20)
            worksheet.merge_range("F1:H1", delivery_date.strftime("%A, %B %d, %Y"), output.book.add_format({"align": "center", "bold": True}))
            worksheet.write("J1", "Total", output.book.add_format({"bold": True}))
            worksheet.write_formula("K1", "=SUBTOTAL(9,K5:K352)")

        with open(file_path, "rb") as f:
            return HttpResponse(
                f.read(),
                content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                headers={"Content-Disposition": f'attachment; filename="{file_name}"'}
            )

    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        if change:  # Only send email if the order is being updated
            SendPulseAPI().send_order_confirmation_to_customer(obj)

    def save_related(self, request, form, formsets, change):
        super().save_related(request, form, formsets, change)
        if change:
            SendPulseAPI().send_order_confirmation_to_customer(form.instance)


admin.site.register(UserOrder, UserOrderAdmin)

# ✅ CSR Admin
@admin.register(CustomerSupportProfile)
class CustomerSupportProfileAdmin(admin.ModelAdmin):
    list_display = ("first_name", "last_name", "email", "phone_number", "extension", "photo_preview")
    search_fields = ("first_name", "last_name", "email")
    readonly_fields = ("photo_preview",)

    def photo_preview(self, obj):
        if obj.photo:
            return format_html('<img src="{}" width="100" height="100" style="border-radius: 10px;" />', obj.photo.url)
        return "(No photo uploaded)"

# ✅ User admin customization
class CustomUserCreationForm(UserCreationForm):
    email = forms.EmailField(required=True)

    schools = forms.ModelMultipleChoiceField(
        queryset=School.objects.all(), required=False, widget=forms.SelectMultiple,
        help_text="Hold down 'Control', or 'Command' on a Mac, to select more than one."
    )

    class Meta:
        model = CustomUser
        fields = ("username", "email", "first_name", "last_name", "password1", "password2", "is_staff", "is_active", "schools")
        exclude = ("groups",)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.instance and self.instance.pk:
            self.fields["schools"].initial = self.instance.schools.all()

    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data["email"]
        if commit:
            user.save()
            user.schools.set(self.cleaned_data["schools"])
        return user


class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = "User Profile"
    fk_name = "user"

@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    inlines = [UserProfileInline]
    list_display = ("username", "email", "first_name", "last_name", "is_staff")

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'first_name', 'last_name', 'password1', 'password2', 'is_staff', 'is_active'),
        }),
    )


    fieldsets = (
        (None, {"fields": ("username", "email", "password")}),
        ("Personal Info", {"fields": ("first_name", "last_name")}),
        ("Permissions", {
            "fields": ("is_active", "is_staff", "is_superuser"),
        }),
    )


    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        if obj.is_staff:
            staff_group, _ = Group.objects.get_or_create(name="Staff")
            obj.groups.add(staff_group)
        UserProfile.objects.get_or_create(user=obj)



    def get_schools(self, obj):
        return ", ".join([s.name for s in obj.schools.all()]) if obj.schools.exists() else "—"

    def get_support_rep(self, obj):
        return obj.profile.support_rep if hasattr(obj, "profile") and obj.profile.support_rep else "—"

    def get_lunch_programs(self, obj):
        programs = set()
        for s in obj.schools.all():
            programs.update(s.lunch_programs.values_list("name", flat=True))
        return ", ".join(sorted(programs)) if programs else "—"

    def get_delivery_schedule(self, obj):
        schedules = set()
        for s in obj.schools.all():
            schedules.update(s.delivery_schedule.values_list("name", flat=True))
        return ", ".join(sorted(schedules)) if schedules else "—"

    def get_route_number_display(self, obj):
        return ", ".join([s.route_number for s in obj.schools.all() if s.route_number]) or "—"

    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        #UserProfile.objects.get_or_create(user=obj)

    get_schools.short_description = "Schools"
    get_support_rep.short_description = "Support Rep"
    get_lunch_programs.short_description = "Lunch Programs"
    get_delivery_schedule.short_description = "Delivery Schedule"
    get_route_number_display.short_description = "Route Number"



# ✅ Re-register with proper label and grouping
User = get_user_model()


#admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(School, SchoolAdmin)
admin.site.register(MilkTypeImage, SuperuserOnlyAdmin)



