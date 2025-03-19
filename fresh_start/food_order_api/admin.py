from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django import forms
from django.utils.translation import gettext_lazy as _
from django.urls import reverse
from django.utils.html import format_html
from django.shortcuts import redirect
from .models import (
    MenuItem, LunchProgram, PlatePortion, MenuDate, UserOrder,
    OrderItem, UserProfile, DeliverySchedule
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


# ✅ Order Management
class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 1

class UserOrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "status", "created_at")
    list_filter = ("status", "created_at")
    search_fields = ("user__username", "id")
    inlines = [OrderItemInline]
    readonly_fields = ["created_at"]
    exclude = ("menu_items",)

admin.site.register(UserOrder, UserOrderAdmin)


# ✅ User Profile Admin
@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ("user", "get_lunch_programs", "get_delivery_schedule")  # ✅ Added 'get_delivery_schedule'
    search_fields = ("user__username",)
    filter_horizontal = ("lunch_programs", "delivery_schedule")  # ✅ Added back 'delivery_schedule'

    def get_lunch_programs(self, obj):
        """Show selected lunch programs as a comma-separated list."""
        return ", ".join([program.name for program in obj.lunch_programs.all()]) if obj.lunch_programs.exists() else "—"

    get_lunch_programs.short_description = "Lunch Programs"

    def get_delivery_schedule(self, obj):
        """Show selected delivery schedules as a comma-separated list."""
        return ", ".join([schedule.name for schedule in obj.delivery_schedule.all()]) if obj.delivery_schedule.exists() else "—"

    get_delivery_schedule.short_description = "Delivery Schedule"


# ✅ UserProfile Inline
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = "User Profile"
    filter_horizontal = ("lunch_programs", "delivery_schedule")  # ✅ Added back 'delivery_schedule'
    fields = ("lunch_programs", "delivery_schedule")  # ✅ Explicitly list fields


# ✅ Custom User Admin with UserProfile Inline
class CustomUserAdmin(UserAdmin):
    inlines = [UserProfileInline]
    list_display = ("username", "email", "get_lunch_programs", "get_delivery_schedule")  # ✅ Added 'get_delivery_schedule'

    def get_lunch_programs(self, obj):
        """Show selected lunch programs as a comma-separated list."""
        if hasattr(obj, 'userprofile'):
            return ", ".join([program.name for program in obj.userprofile.lunch_programs.all()])
        return "—"

    get_lunch_programs.short_description = "Lunch Programs"

    def get_delivery_schedule(self, obj):
        """Show selected delivery schedules as a comma-separated list."""
        if hasattr(obj, 'userprofile'):
            return ", ".join([schedule.name for schedule in obj.userprofile.delivery_schedule.all()])
        return "—"

    get_delivery_schedule.short_description = "Delivery Schedule"

# ✅ Unregister and re-register User model
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)
