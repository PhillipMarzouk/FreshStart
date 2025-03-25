from django.db import models
from datetime import timedelta
from django.contrib import admin
from django.core.files.storage import default_storage
from django.utils.html import mark_safe
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User, AbstractUser, Group, Permission
from django.core.exceptions import ValidationError
import os

class FoodType(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class FoodItem(models.Model):
    name = models.CharField(max_length=100)
    food_type = models.ForeignKey(FoodType, on_delete=models.CASCADE, related_name='food_items')
    price = models.DecimalField(max_digits=6, decimal_places=2)

    def __str__(self):
        return self.name


# Meal Type Choices
MEAL_TYPE_CHOICES = [
    ("Breakfast", "Breakfast"),
    ("Hot Meal", "Hot Meal"),
    ("Hot Vegetarian", "Hot Vegetarian"),
    ("Cold Meal", "Cold Meal"),
    ("Cold Pastas", "Cold Pastas"),
    ("Cold Vegetarian", "Cold Vegetarian"),
    ("Daily Salad", "Daily Salad"),
    ("Snack", "Snack"),
]


# Function to validate allowed image formats
def validate_image_extension(value):
    ext = os.path.splitext(value.name)[1].lower()  # Get the file extension
    allowed_extensions = ['.jpg', '.jpeg', '.png', '.webp', '.avif']
    if ext not in allowed_extensions:
        raise ValidationError(f"Unsupported file format: {ext}. Allowed formats: {', '.join(allowed_extensions)}")


# Lunch Program Model
class LunchProgram(models.Model):
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name


# Plate Portion Model
class PlatePortion(models.Model):
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name


# Date Availability Model
class MenuDate(models.Model):
    date = models.DateField(unique=True)  # Each date is stored here

    def __str__(self):
        return self.date.strftime("%Y-%m-%d")  # Format date as YYYY-MM-DD


# Delivery Schedule Model
class DeliverySchedule(models.Model):
    DAYS_OF_WEEK = [
        ("Monday", "Monday"),
        ("Tuesday", "Tuesday"),
        ("Wednesday", "Wednesday"),
        ("Thursday", "Thursday"),
        ("Friday", "Friday"),
    ]

    name = models.CharField(max_length=20, choices=DAYS_OF_WEEK, unique=True)

    def __str__(self):
        return self.name


# Customer Support Profile Model
class CustomerSupportProfile(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=15)
    extension = models.CharField(max_length=10, blank=True, null=True)
    photo = models.ImageField(upload_to="support_profiles/", blank=True, null=True)

    def photo_preview(self):
        """Display a placeholder if no photo is uploaded."""
        if self.photo:
            return mark_safe(f'<img src="{self.photo.url}" width="100" height="100" style="border-radius: 10px;" />')
        return "(No photo uploaded)"

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class School(models.Model):
    DELIVERY_TYPE_CHOICES = [
        ("Ready to Serve", "Ready to Serve"),
        ("Heat on Site", "Heat on Site"),
    ]

    name = models.CharField(max_length=255, unique=True)
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name="schools")
    users = models.ManyToManyField(User, related_name="schools")
    lunch_programs = models.ManyToManyField("food_order_api.LunchProgram", blank=True)  # ✅ FIXED: String reference
    delivery_schedule = models.ManyToManyField("food_order_api.DeliverySchedule", blank=True)  # ✅ FIXED: String reference

    route_number = models.CharField(
        max_length=2,
        blank=True,
        null=True,
        help_text="Enter a 2-digit route number",
    )
    delivery_type = models.CharField(
        max_length=20,
        choices=DELIVERY_TYPE_CHOICES,
        blank=True,
        null=True,
        help_text="Select the delivery type."
    )

    class Meta:
        app_label = "auth"
        verbose_name_plural = "Schools"

    def __str__(self):
        return self.name








class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile", unique=True)
    support_rep = models.ForeignKey(
        'CustomerSupportProfile', on_delete=models.SET_NULL, blank=True, null=True, related_name="assigned_users"
    )
    additional_notes = models.TextField(
        blank=True,
        null=True,
        help_text="Enter any additional notes."
    )


    def get_support_rep_display(self):
        return self.support_rep if self.support_rep else "—"

    def get_additional_notes_display(self):
        return self.additional_notes if self.additional_notes else "—"

    get_support_rep_display.short_description = "Support Rep"
    get_additional_notes_display.short_description = "Additional Notes"

    def __str__(self):
        return self.user.username



@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.profile.save()

# Update UserProfile to include a ForeignKey to CustomerSupportProfile
#class UserProfile(models.Model):
#    user = models.OneToOneField(User, on_delete=models.CASCADE)
#    lunch_programs = models.ManyToManyField(LunchProgram, blank=True, related_name="users")
#    delivery_schedule = models.ManyToManyField(DeliverySchedule, blank=True, related_name="users")
#    support_rep = models.ForeignKey(CustomerSupportProfile, on_delete=models.SET_NULL, blank=True, null=True, related_name="assigned_users")

#    def __str__(self):
#        return self.user.username


# ✅ Auto-create UserProfile when a User is created
#@receiver(post_save, sender=User)
#def create_user_profile(sender, instance, created, **kwargs):
#    if created:
#        UserProfile.objects.create(user=instance)

#@receiver(post_save, sender=User)
#def save_user_profile(sender, instance, **kwargs):
#    instance.userprofile.save()


# Menu Item Model
class MenuItem(models.Model):
    plate_name = models.CharField(max_length=255)

    meal_type = models.CharField(
        max_length=50,
        choices=MEAL_TYPE_CHOICES
    )

    lunch_programs = models.ManyToManyField(LunchProgram, blank=True)  # Filter menu based on lunch program
    plate_portions = models.ManyToManyField(PlatePortion, blank=True)

    is_new = models.BooleanField(default=False)

    available_date = models.DateField(null=True, blank=True)

    image = models.ImageField(
        upload_to="menu_images/",
        blank=True,
        null=True,
        validators=[validate_image_extension]
    )

    def __str__(self):
        return self.plate_name


# Cart Model
class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    menu_item = models.ForeignKey(MenuItem, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)

    class Meta:
        unique_together = ('user', 'menu_item')

    def __str__(self):
        return f'{self.quantity} x {self.menu_item.plate_name} in {self.user.username}\'s cart'


class UserOrder(models.Model):
    STATUS_CHOICES = [
        ("Pending", "Pending"),
        ("Order Received", "Order Received"),
        ("Paid", "Paid"),
        ("Manufactured", "Manufactured"),
        ("Shipped", "Shipped"),
        ("Delivered", "Delivered"),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="orders")
    menu_items = models.ManyToManyField("MenuItem")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="Pending")
    created_at = models.DateTimeField(auto_now_add=True)
    quantity = models.PositiveIntegerField(default=1)
    school = models.ForeignKey(School, on_delete=models.CASCADE, related_name="orders", null=True, blank=True)

    class Meta:
        verbose_name = "Customer Orders"
        verbose_name_plural = "Customer Orders"

    def __str__(self):
        return f"Order {self.id} - {self.user.username} ({self.status})"





class OrderItem(models.Model):
    order = models.ForeignKey("UserOrder", on_delete=models.CASCADE, related_name="order_items")
    menu_item = models.ForeignKey("MenuItem", on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    menu_item_date = models.DateField(null=True, blank=True, default=None)
    delivery_date = models.DateField(null=True, blank=True, default=None)  # ✅ New Field

    def __str__(self):
        return f"{self.quantity}x {self.menu_item.plate_name} in Order #{self.order.id} (Date: {self.menu_item_date}, Delivery: {self.delivery_date})"

    def save(self, *args, **kwargs):
        """Automatically calculate or update delivery date."""
        if self.menu_item_date:
            self.delivery_date = self.calculate_delivery_date(self.menu_item_date)
        super().save(*args, **kwargs)

    def calculate_delivery_date(self, consumption_date):
        """Determine the delivery date based on the user's school delivery schedule."""
        user_schools = self.order.user.schools.all()

        delivery_days = set()
        for school in user_schools:
            delivery_days.update(school.delivery_schedule.values_list("name", flat=True))

        if not delivery_days:
            return consumption_date - timedelta(days=2)

        for days_prior in range(1, 7):
            potential_delivery = consumption_date - timedelta(days=days_prior)
            if potential_delivery.strftime("%A") in delivery_days:
                return potential_delivery

        return consumption_date - timedelta(days=2)




#class OrderItem(models.Model):
#    order = models.ForeignKey(UserOrder, on_delete=models.CASCADE, related_name="order_items")
#    menu_item = models.ForeignKey("MenuItem", on_delete=models.CASCADE)
#    quantity = models.PositiveIntegerField(default=1)
#    menu_item_date = models.DateField(null=True, blank=True, default=None)

#    def __str__(self):
#        return f"{self.quantity}x {self.menu_item.plate_name} in Order #{self.order.id} (Date: {self.menu_item_date})"


class CustomUser(AbstractUser):
    lunch_programs = models.ManyToManyField(
        'LunchProgram',
        blank=True,
        related_name="custom_users"
    )
    delivery_schedule = models.ManyToManyField(
        'DeliverySchedule',
        blank=True,
        related_name="custom_users"
    )
    support_rep = models.ForeignKey(
        'CustomerSupportProfile',
        on_delete=models.SET_NULL,
        blank=True,
        null=True,
        related_name="assigned_custom_users"
    )

    # ✅ Fix: Add related_name attributes to avoid clashes with auth.User
    groups = models.ManyToManyField(Group, related_name="customuser_set", blank=True)
    user_permissions = models.ManyToManyField(Permission, related_name="customuser_permissions_set", blank=True)

    def get_lunch_programs_display(self):
        return ", ".join([program.name for program in self.lunch_programs.all()]) if self.lunch_programs.exists() else "—"

    def get_delivery_schedule_display(self):
        return ", ".join([schedule.name for schedule in self.delivery_schedule.all()]) if self.delivery_schedule.exists() else "—"

    def get_support_rep_display(self):
        return self.support_rep if self.support_rep else "—"

    def get_route_number_display(self):
        return self.route_number if self.route_number else "—"



    get_lunch_programs_display.short_description = "Lunch Programs"
    get_delivery_schedule_display.short_description = "Delivery Schedule"
    get_support_rep_display.short_description = "Support Rep"
    get_route_number_display.short_description = "Route Number"