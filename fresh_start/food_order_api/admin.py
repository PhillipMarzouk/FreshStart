import pandas as pd
import datetime

from django.contrib import admin
from django.http import HttpResponse
from django.utils.safestring import mark_safe
from django.urls import path
from django.shortcuts import render

from django.contrib.auth.admin import UserAdmin, GroupAdmin
from django.contrib.auth.models import User, Group
from django import forms
from django.urls import reverse
from django.utils.html import format_html
from .models import (
    MenuItem, PlatePortion, MenuDate, LunchProgram, DeliverySchedule,
    UserOrder, OrderItem, CustomerSupportProfile, UserProfile, School
)

# ✅ Register models safely to prevent duplication
for model in [LunchProgram, PlatePortion, MenuDate, DeliverySchedule]:
    if not admin.site.is_registered(model):
        admin.site.register(model)


# ✅ Menu Item Form with Date Picker
class MenuItemForm(forms.ModelForm):
    available_date = forms.DateField(
        widget=forms.DateInput(attrs={'type': 'date'})
    )

    class Meta:
        model = MenuItem
        fields = '__all__'


# ✅ Menu Item Admin
class MenuItemAdmin(admin.ModelAdmin):
    form = MenuItemForm
    list_display = ("menu_item_actions", "meal_type", "available_date", "is_new")
    search_fields = ("plate_name", "meal_type")
    list_filter = ("meal_type", "is_new", "available_date")
    ordering = ("plate_name",)
    readonly_fields = ("image_preview",)

    # ✅ Keep only filter_horizontal for many-to-many relationships
    filter_horizontal = ("lunch_programs", "plate_portions")

    def image_preview(self, obj):
        """Show image preview in admin."""
        if obj.image:
            return format_html('<img src="{}" width="100" height="100" style="border-radius: 10px;" />', obj.image.url)
        return "(No image uploaded)"

    def menu_item_actions(self, obj):
        """Display menu item name with quick action links below"""
        edit_url = reverse("admin:food_order_api_menuitem_change", args=[obj.id])
        delete_url = reverse("admin:food_order_api_menuitem_delete", args=[obj.id])
        clone_url = reverse("menu_item_clone", args=[obj.id])

        return format_html(
            """
            <strong style="font-size: 18px;">
                <a href="{}">{}</a>
            </strong>
            <br>
            <span style="font-size: 13px; font-weight: 300; padding-top: 3px;">
                <a href='{}' style="padding-right: 10px;">Edit</a>
                <a href='{}' style="color: #dc3545; padding-right: 10px;">Trash</a>
                <a href='{}'>Clone</a>
            </span>
            """,
            edit_url, obj.plate_name,
            edit_url, delete_url, clone_url
        )

    menu_item_actions.short_description = "Menu Item"

admin.site.register(MenuItem, MenuItemAdmin)


@admin.register(School)
class SchoolAdmin(admin.ModelAdmin):
    list_display = ("name", "group", "display_lunch_programs", "display_delivery_schedule", "route_number", "delivery_type")
    search_fields = ("name",)
    filter_horizontal = ("lunch_programs", "delivery_schedule")

    def display_lunch_programs(self, obj):
        return ", ".join([program.name for program in obj.lunch_programs.all()]) if obj.lunch_programs.exists() else "—"

    def display_delivery_schedule(self, obj):
        return ", ".join([schedule.name for schedule in obj.delivery_schedule.all()]) if obj.delivery_schedule.exists() else "—"

    display_lunch_programs.short_description = "Lunch Programs"
    display_delivery_schedule.short_description = "Delivery Schedule"


# ✅ Order Management
class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 1
    fields = ["menu_item", "quantity", "menu_item_date", "delivery_date"]  # ✅ Include both dates
    readonly_fields = []  # ✅ Ensure both fields are editable

class UserOrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "status", "created_at")
    list_filter = ("status", "created_at")
    search_fields = ("user__username", "id")
    inlines = [OrderItemInline]
    readonly_fields = ["created_at"]
    exclude = ("menu_items",)

    # ✅ Add Export Button using Media class
    class Media:
        js = ('admin/js/export_production.js',)  # Injects JavaScript to add the button

    # ✅ Add custom export URL
    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path("export-excel/", self.admin_site.admin_view(self.export_production_excel), name="export_production_excel"),
        ]
        return custom_urls + urls

    # ✅ Export function (uses selected date)
    def export_production_excel(self, request):
        selected_date = request.GET.get("date")
        if not selected_date:
            return HttpResponse("Please select a valid date.", status=400)

        try:
            delivery_date = datetime.datetime.strptime(selected_date, "%Y-%m-%d").date()
        except ValueError:
            return HttpResponse("Invalid date format.", status=400)

        # Fetch all orders with the selected delivery date
        order_items = OrderItem.objects.filter(delivery_date=delivery_date)

        # Prepare Data
        data = []
        for item in order_items:
            user = item.order.user
            profile = getattr(user, "profile", None)
            #csr_rep = getattr(profile.customer_support_rep, "name", "N/A") if profile else "N/A"
            csr_rep = "N/A"
            if profile and profile.support_rep:
                csr_rep = str(profile.support_rep)
            route_number = getattr(profile, "route_number", "N/A")
            school_name = getattr(profile, "school_name", "N/A")
            delivery_type = getattr(profile, "delivery_type", "N/A")

            data.append([
                "",  # Column A (Blank)
                item.delivery_date,  # Column B (Delivery Date)
                item.menu_item_date,  # Column C (Consumption Date)
                "",  # Column D (Type - Blank)
                csr_rep,  # Column E (CSR Rep)
                "",  # Column F (Time - Blank)
                route_number,  # Column G (Route Number)
                school_name,  # Column H (School Name)
                "",  # Column I (Grade - Blank)
                "",  # Column J (Production Notes - Blank)
                item.quantity,  # Column K (Count)
                item.menu_item.plate_name,  # Column L (Menu Item)
                "",  # Column M (Containers - Blank)
                "",  # Column N (V no. - Blank)
                delivery_type,  # Column O (Delivery Type)
                "",  # Column P (Student Name - Blank)
                "",  # Column Q (Remarks - Blank)
            ])

        # Convert to DataFrame
        df = pd.DataFrame(data, columns=[
            "", "Delivery Date", "Consumption Date", "Type", "CSR REP", "Time", "Route Number", "School Name",
            "Grade", "Production Notes", "Count", "Menu", "Containers", "V no.", "Delivery Type", "Student Name", "Remarks"
        ])

        # Apply Formatting
        file_name = f"FINAL PRODUCTION {delivery_date.strftime('%B %d, %Y')}.xlsx"
        output = pd.ExcelWriter(file_name, engine="xlsxwriter")
        df.to_excel(output, index=False, sheet_name="Production Sheet", startrow=3)

        # Get Workbook and Worksheet objects
        workbook = output.book
        worksheet = output.sheets["Production Sheet"]

        # ✅ Format Row 1
        worksheet.set_row(0, 20)
        worksheet.merge_range("F1:H1", delivery_date.strftime("%A, %B %d, %Y"), workbook.add_format({"align": "center", "bold": True}))

        # ✅ Set Total Formula in K1
        worksheet.write("J1", "Total", workbook.add_format({"bold": True}))
        worksheet.write_formula("K1", "=SUBTOTAL(9,K5:K352)")

        # ✅ Save File
        output.close()

        # Serve the file for download
        response = HttpResponse(open(file_name, "rb").read(), content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        response["Content-Disposition"] = f'attachment; filename="{file_name}"'
        return response

# ✅ Register Admin
admin.site.register(UserOrder, UserOrderAdmin)

# ✅ Customer Support Profile Admin
@admin.register(CustomerSupportProfile)
class CustomerSupportProfileAdmin(admin.ModelAdmin):
    list_display = ("first_name", "last_name", "email", "phone_number", "extension", "photo_preview")
    search_fields = ("first_name", "last_name", "email")
    readonly_fields = ("photo_preview",)  # To show image preview in admin

    def photo_preview(self, obj):
        """Show image preview in admin."""
        if obj.photo:
            return format_html('<img src="{}" width="100" height="100" style="border-radius: 10px;" />', obj.photo.url)
        return "(No photo uploaded)"


# ✅ Attach UserProfile to the default User model
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = "User Profile"
    fields = ("support_rep", "additional_notes")




# ✅ Custom Form for UserAdmin (Removes Groups and Adds Schools)
class CustomUserChangeForm(forms.ModelForm):
    schools = forms.ModelMultipleChoiceField(
        queryset=School.objects.all(),
        required=False,
        widget=forms.SelectMultiple,  # ✅ Change to multi-select dropdown
        help_text="Hold down 'Control', or 'Command' on a Mac, to select more than one."
    )

    class Meta:
        model = User
        fields = ("username", "email", "first_name", "last_name", "is_staff", "is_active", "schools")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        if self.instance and self.instance.pk:
            self.fields["schools"].initial = self.instance.schools.all()  # ✅ Load existing schools

    def save(self, commit=True):
        user = super().save(commit=False)
        if commit:
            user.save()
            user.schools.set(self.cleaned_data["schools"])  # ✅ Update school relationships
        return user


class CustomUserAdmin(UserAdmin):
    form = CustomUserChangeForm
    #inlines = [UserProfileInline]  # ✅ Keep UserProfile inline
    list_display = (
        "username", "email", "first_name", "last_name", "is_staff",
        "get_schools", "get_support_rep", "get_lunch_programs", "get_delivery_schedule",
        "get_route_number_display"
    )

    fieldsets = (
        (None, {"fields": ("username", "email", "password")}),
        ("Personal Info", {"fields": ("first_name", "last_name")}),
        ("Permissions", {"fields": ("is_active", "is_staff", "is_superuser")}),
        ("Schools", {"fields": ("schools",)}),  # ✅ Schools now use a multi-select dropdown
    )

    filter_horizontal = ("user_permissions")


    def get_schools(self, obj):
        """Display user's associated schools."""
        return ", ".join([school.name for school in obj.schools.all()]) if obj.schools.exists() else "—"

    def get_support_rep(self, obj):
        """Fetch support rep from UserProfile."""
        return obj.profile.support_rep if hasattr(obj, "profile") and obj.profile.support_rep else "—"

    def get_lunch_programs(self, obj):
        """Fetch lunch programs from schools the user is linked to."""
        schools = obj.schools.all()
        lunch_programs = set()
        for school in schools:
            lunch_programs.update(school.lunch_programs.values_list("name", flat=True))
        return ", ".join(sorted(lunch_programs)) if lunch_programs else "—"

    def get_delivery_schedule(self, obj):
        """Fetch delivery schedules from schools the user is linked to."""
        schools = obj.schools.all()
        delivery_schedules = set()
        for school in schools:
            delivery_schedules.update(school.delivery_schedule.values_list("name", flat=True))
        return ", ".join(sorted(delivery_schedules)) if delivery_schedules else "—"

    def get_route_number_display(self, obj):
        """Show route number(s) from user's schools."""
        schools = obj.schools.all()
        route_numbers = [school.route_number for school in schools if school.route_number]
        return ", ".join(route_numbers) if route_numbers else "—"

    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        # Ensure UserProfile exists without causing duplicates
        UserProfile.objects.get_or_create(user=obj)


    get_schools.short_description = "Schools"
    get_support_rep.short_description = "Support Rep"
    get_lunch_programs.short_description = "Lunch Programs"
    get_delivery_schedule.short_description = "Delivery Schedule"
    get_route_number_display.short_description = "Route Number"


# ✅ Unregister default UserAdmin and register the custom version
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)

