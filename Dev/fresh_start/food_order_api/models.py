from django.db import models
from datetime import timedelta
from django.contrib import admin
from django.core.files.storage import default_storage
from django.utils.html import mark_safe
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.core.exceptions import ValidationError
import os
import json

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


MEAL_TYPE_CHOICES = [
    ("Breakfast", "Breakfast"),
    ("Breakfast Cereal", "Breakfast Cereal"),
    ("Hot Meal", "Hot Meal"),
    ("Hot Vegetarian", "Hot Vegetarian"),
    ("Cold Meal", "Cold Meal"),
    ("Cold Pastas", "Cold Pastas"),
    ("Cold Vegetarian", "Cold Vegetarian"),
    ("Daily Salad", "Daily Salad"),
    ("Snack", "Snack"),
    ("Vegan", "Vegan"),
    ("Therapeutic", "Therapeutic"),
    ("Milk", "Milk"),
]


DAYS_OF_WEEK = [
    ("mon", "Monday"),
    ("tue", "Tuesday"),
    ("wed", "Wednesday"),
    ("thu", "Thursday"),
    ("fri", "Friday"),
]



def validate_image_extension(value):
    ext = os.path.splitext(value.name)[1].lower()
    allowed_extensions = ['.jpg', '.jpeg', '.png', '.webp', '.avif']
    if ext not in allowed_extensions:
        raise ValidationError(f"Unsupported file format: {ext}. Allowed formats: {', '.join(allowed_extensions)}")


class LunchProgram(models.Model):
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name


class PlatePortion(models.Model):
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name


class MenuDate(models.Model):
    date = models.DateField(unique=True)

    def __str__(self):
        return self.date.strftime("%Y-%m-%d")


class DeliverySchedule(models.Model):
    DAYS_OF_WEEK = [(day, day) for day in ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]]
    name = models.CharField(max_length=20, choices=DAYS_OF_WEEK, unique=True)

    def __str__(self):
        return self.name


class CustomerSupportProfile(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(unique=True, blank=False, null=False)
    phone_number = models.CharField(max_length=15)
    extension = models.CharField(max_length=10, blank=True, null=True)
    photo = models.ImageField(upload_to="support_profiles/", blank=True, null=True)

    def photo_preview(self):
        if self.photo:
            return mark_safe(f'<img src="{self.photo.url}" width="100" height="100" style="border-radius: 10px;" />')
        return "(No photo uploaded)"

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class SchoolGroup(models.Model):
    name = models.CharField(max_length=255, unique=True)

    def __str__(self):
        return self.name


class School(models.Model):
    DELIVERY_TYPE_CHOICES = [("Cold Only", "Cold Only"), ("Ready to Serve", "Ready to Serve"), ("Heat on Site", "Heat on Site")]
    GRADE_LEVEL_CHOICES = [("Pre-school", "Pre-school"), ("K-8", "K-8"), ("9-12", "9-12"), ("Adult", "Adult")]

    name = models.CharField(max_length=255, unique=True)
    group = models.ForeignKey(SchoolGroup, on_delete=models.SET_NULL, null=True, blank=True, related_name="schools")
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name="schools")
    lunch_programs = models.ManyToManyField(LunchProgram, blank=True)
    delivery_schedule = models.ManyToManyField(DeliverySchedule, blank=True)
    pizza_days = models.JSONField(default=list, blank=True, help_text="List of weekdays when pizza is served (e.g. [\"mon\", \"wed\"])")
    family_style_days = models.JSONField(default=list, blank=True, help_text='Days for Family Style service (e.g. [\"mon\", \"wed\"])')


    breakfast_milk_distribution = models.JSONField(default=dict, blank=True)
    cereal_milk_distribution = models.JSONField(default=dict, blank=True)
    lunch_milk_distribution = models.JSONField(default=dict, blank=True)
    snack_milk_distribution = models.JSONField(default=dict, blank=True)
    vegan_milk_distribution = models.JSONField(default=dict, blank=True)
    therapeutic_milk_distribution = models.JSONField(default=dict, blank=True)

    grade_level = models.CharField(max_length=20, choices=GRADE_LEVEL_CHOICES, blank=True, null=True)
    route_number = models.CharField(max_length=2, blank=True, null=True)
    delivery_type = models.CharField(max_length=20, choices=DELIVERY_TYPE_CHOICES, blank=True, null=True)

    def clean(self):
        for field_name in [
            "breakfast_milk_distribution",
            "cereal_milk_distribution",
            "lunch_milk_distribution",
            "snack_milk_distribution",
            "therapeutic_milk_distribution",
        ]:
            dist = getattr(self, field_name, {}) or {}
            if isinstance(dist, str):
                try:
                    dist = json.loads(dist)
                except json.JSONDecodeError:
                    continue
            total = sum(int(v) for v in dist.values() if v != "")
            if total != 100:
                raise ValidationError({field_name: f"{field_name.replace('_', ' ').title()}: Must total 100%."})

    def __str__(self):
        return self.name

    class Meta:
        app_label = 'food_order_api'


class MilkTypeImage(models.Model):
    name = models.CharField(max_length=100, unique=True)
    image = models.ImageField(upload_to="milk_images/")

    def __str__(self):
        return self.name


class UserProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="profile", unique=True)
    support_rep = models.ForeignKey(CustomerSupportProfile, on_delete=models.SET_NULL, blank=True, null=True, related_name="assigned_users")
    additional_notes = models.TextField(blank=True, null=True)

    def get_support_rep_display(self):
        return self.support_rep if self.support_rep else "—"

    def get_additional_notes_display(self):
        return self.additional_notes if self.additional_notes else "—"

    get_support_rep_display.short_description = "Support Rep"
    get_additional_notes_display.short_description = "Additional Notes"

    def __str__(self):
        return self.user.username


#@receiver(post_save, sender=settings.AUTH_USER_MODEL)
#def create_user_profile(sender, instance, created, **kwargs):
#    if created:
#        UserProfile.objects.create(user=instance)


class MenuItem(models.Model):
    plate_name = models.CharField(max_length=255)
    meal_type = models.CharField(max_length=50, choices=MEAL_TYPE_CHOICES)
    lunch_programs = models.ManyToManyField(LunchProgram, blank=True)
    plate_portions = models.ManyToManyField(PlatePortion, blank=True)
    is_field_trip = models.BooleanField(default=False)
    is_new = models.BooleanField(default=False)
    available_date = models.DateField(null=True, blank=True)
    image = models.ImageField(upload_to="menu_images/", blank=True, null=True, validators=[validate_image_extension])

    def __str__(self):
        return self.plate_name

    class Meta:
        verbose_name_plural = "Menu Items"


class Cart(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    menu_item = models.ForeignKey(MenuItem, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    date_override = models.DateField(null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=["user", "menu_item", "date_override"], name="unique_cart_per_day")
        ]

    def __str__(self):
        return f'{self.quantity} x {self.menu_item.plate_name} in {self.user.username}\'s cart'


class UserOrder(models.Model):
    STATUS_CHOICES = [("Pending", "Pending"), ("Nutrition Review", "Nutrition Review"), ("Approved", "Approved"), ("ON HOLD", "ON HOLD")]
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="orders")
    menu_items = models.ManyToManyField(MenuItem)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="Pending")
    created_at = models.DateTimeField(auto_now_add=True)
    quantity = models.PositiveIntegerField(default=1)
    school = models.ForeignKey(School, on_delete=models.CASCADE, related_name="orders", null=True, blank=True)
    notes = models.TextField(blank=True, null=True)
    staff_notes = models.TextField(blank=True, null=True)

    class Meta:
        verbose_name = "Orders"
        verbose_name_plural = "Orders"

    def __str__(self):
        return f"Order {self.id} - {self.user.username} ({self.status})"


class OrderItem(models.Model):
    order = models.ForeignKey(UserOrder, on_delete=models.CASCADE, related_name="order_items")
    menu_item = models.ForeignKey(MenuItem, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    menu_item_date = models.DateField(null=True, blank=True, default=None)
    delivery_date = models.DateField(null=True, blank=True, default=None)

    def __str__(self):
        return f"{self.quantity}x {self.menu_item.plate_name} in Order #{self.order.id} (Date: {self.menu_item_date}, Delivery: {self.delivery_date})"

    def save(self, *args, **kwargs):
        if not self.delivery_date and self.menu_item_date:
            self.delivery_date = self.calculate_delivery_date(self.menu_item_date)
        super().save(*args, **kwargs)

    def calculate_delivery_date(self, consumption_date):
        user_schools = self.order.user.schools.all()
        delivery_days = set()
        for school in user_schools:
            delivery_days.update(school.delivery_schedule.values_list("name", flat=True))
        for days_prior in range(1, 7):
            potential_delivery = consumption_date - timedelta(days=days_prior)
            if potential_delivery.strftime("%A") in delivery_days:
                return potential_delivery
        return consumption_date - timedelta(days=2)


class CustomUser(AbstractUser):
    lunch_programs = models.ManyToManyField(LunchProgram, blank=True, related_name="custom_users")
    delivery_schedule = models.ManyToManyField(DeliverySchedule, blank=True, related_name="custom_users")
    support_rep = models.ForeignKey(CustomerSupportProfile, on_delete=models.SET_NULL, blank=True, null=True, related_name="assigned_custom_users")

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

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

        # ✅ Ensure Staff group is assigned after user is saved
        if self.is_staff:
            staff_group, _ = Group.objects.get_or_create(name="Staff")
            self.groups.add(staff_group)
        else:
            self.groups.remove(*self.groups.filter(name="Staff"))

    get_lunch_programs_display.short_description = "Lunch Programs"
    get_delivery_schedule_display.short_description = "Delivery Schedule"
    get_support_rep_display.short_description = "Support Rep"
    get_route_number_display.short_description = "Route Number"

    class Meta:
        app_label = 'food_order_api'
        verbose_name_plural = "Users"


@receiver(post_save, sender=CustomUser)
def save_user_profile(sender, instance, created, **kwargs):
    if created and not hasattr(instance, "profile"):
        UserProfile.objects.create(user=instance)

