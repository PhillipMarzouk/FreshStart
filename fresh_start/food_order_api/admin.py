from django.contrib import admin
from django.contrib.auth.models import Group, User
from django import forms
from django.utils.translation import gettext_lazy as _
from django.http import HttpResponseRedirect
from django.shortcuts import redirect
from django.utils.html import format_html
from django.contrib import messages
from django.shortcuts import render
from django.urls import reverse
from .models import MenuItem, LunchProgram, PlatePortion, MenuDate, UserOrder, OrderItem
from datetime import date


class MenuItemForm(forms.ModelForm):
    available_date = forms.DateField(
        widget=forms.DateInput(attrs={'type': 'date'})  # Enables HTML5 date picker
    )

    class Meta:
        model = MenuItem
        fields = '__all__'

class MenuItemAdmin(admin.ModelAdmin):
    form = MenuItemForm
    list_display = ("menu_item_actions", "meal_type", "available_date", "is_new")  # ✅ Updated to show quick actions
    search_fields = ("plate_name", "meal_type")
    list_filter = ("meal_type", "is_new", "available_date")
    ordering = ("plate_name",)
    readonly_fields = ("image_preview",)

    def image_preview(self, obj):
        """Show image preview in admin."""
        if obj.image:
            return format_html('<img src="{}" width="100" height="100" style="border-radius: 10px;" />', obj.image.url)
        return "(No image uploaded)"
    
    image_preview.allow_tags = True
    image_preview.short_description = "Preview"

    def menu_item_actions(self, obj):
        """Display menu item name with quick action links below"""
        edit_url = reverse("admin:food_order_api_menuitem_change", args=[obj.id])
        delete_url = reverse("admin:food_order_api_menuitem_delete", args=[obj.id])
        clone_url = reverse("admin:menu_item_clone", args=[obj.id])  # ✅ Fix: Registered this in admin URLs

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

    def clone_menu_item(self, request, obj_id):
        """Clones the selected menu item, including lunch programs & plate portions."""
        try:
            original_item = MenuItem.objects.get(id=obj_id)
            new_item = MenuItem.objects.get(id=obj_id)
            new_item.id = None  # Creates a new entry
            new_item.plate_name = f"{original_item.plate_name} (copy)"
            new_item.save()  # ✅ Must save first before assigning ManyToMany fields

            # ✅ Copy many-to-many relationships
            new_item.lunch_programs.set(original_item.lunch_programs.all())
            new_item.plate_portions.set(original_item.plate_portions.all())

            messages.success(request, f'"{original_item.plate_name}" was successfully duplicated.')

        except MenuItem.DoesNotExist:
            messages.error(request, "The selected item could not be found.")

        return redirect("admin:food_order_api_menuitem_changelist")


    def get_urls(self):
        """Register a custom URL for the Clone action."""
        from django.urls import path
        urls = super().get_urls()
        custom_urls = [
            path("clone/<int:obj_id>/", self.admin_site.admin_view(self.clone_menu_item), name="menu_item_clone"),
        ]
        return custom_urls + urls  # ✅ Prepend custom URLs to default Django admin URLs

    # Bulk action function must be inside `MenuItemAdmin`
    def bulk_update_available_date(self, request, queryset):
        print("🔹 bulk_update_available_date function was called.")  # ✅ Debugging print

        # ✅ Show form first before processing POST request
        if request.method == "POST":
            print("🔹 Received POST request!")  # ✅ Confirm POST request

            new_date = request.POST.get("available_date")
            selected_ids = request.POST.getlist("_selected_action")  # ✅ Get selected IDs

            if not new_date:
                print("🔹 No date selected! Redirecting...")  # ✅ Debugging print
                messages.error(request, "No date selected. Please try again.")
                return HttpResponseRedirect(request.get_full_path())

            print(f"🔹 Updating {len(selected_ids)} items to {new_date}")  # ✅ Debugging print

            queryset = MenuItem.objects.filter(pk__in=selected_ids)
            updated_count = queryset.update(available_date=new_date)

            if updated_count > 0:
                print(f"🔹 Successfully updated {updated_count} items.")  # ✅ Debugging print
                messages.success(request, f"{updated_count} menu items updated successfully.")
            else:
                print("🔹 No items were updated.")  # ✅ Debugging print
                messages.warning(request, "No items were updated. Please check your selection.")

            return HttpResponseRedirect(reverse("admin:food_order_api_menuitem_changelist"))

        # ✅ If it's a GET request, show the form instead of processing data
        print("🔹 Rendering bulk update form...")  # ✅ Debugging print
        return render(request, "admin/bulk_update_available_date.html", {"items": queryset})


    bulk_update_available_date.short_description = _("Bulk Update Available Date")

admin.site.register(MenuItem, MenuItemAdmin)
admin.site.register(LunchProgram)
admin.site.register(PlatePortion)
admin.site.register(MenuDate)


class OrderItemInline(admin.TabularInline):  # ✅ Keeps menu items in a separate section
    model = OrderItem
    extra = 1  # Allows adding items manually

class UserOrderAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "status", "created_at")
    list_filter = ("status", "created_at")
    search_fields = ("user__username", "id")
    inlines = [OrderItemInline]  # ✅ Only displays menu items inside inline

    # ✅ Remove menu_items & quantity fields from the top
    def get_fields(self, request, obj=None):
        fields = ["user", "status", "created_at"]  # ✅ Keep only necessary fields
        return fields

    # ✅ Make `created_at` field read-only (optional)
    readonly_fields = ["created_at"]

admin.site.register(UserOrder, UserOrderAdmin)