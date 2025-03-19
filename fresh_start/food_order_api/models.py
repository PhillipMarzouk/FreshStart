from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
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


# ✅ Updated User Profile Model (Now using direct ManyToMany fields)
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    lunch_programs = models.ManyToManyField(LunchProgram, blank=True, related_name="users")
    delivery_schedule = models.ManyToManyField(DeliverySchedule, blank=True, related_name="users")

    def __str__(self):
        return self.user.username


# ✅ Auto-create UserProfile when a User is created
@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    instance.userprofile.save()


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


# Order Models
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

    class Meta:
        verbose_name = "Customer Orders"
        verbose_name_plural = "Customer Orders"

    def __str__(self):
        return f"Order {self.id} - {self.user.username} ({self.status})"


class OrderItem(models.Model):
    order = models.ForeignKey(UserOrder, on_delete=models.CASCADE, related_name="order_items")
    menu_item = models.ForeignKey("MenuItem", on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    menu_item_date = models.DateField(null=True, blank=True, default=None)

    def __str__(self):
        return f"{self.quantity}x {self.menu_item.plate_name} in Order #{self.order.id} (Date: {self.menu_item_date})"
