from django.db import models
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

# Lunch Program Choices
LUNCH_PROGRAM_CHOICES = [
    ("NSLP K-8", "NSLP K-8"),
    ("NSLP 9-12", "NSLP 9-12"),
    ("CACFP K-12", "CACFP K-12"),
    ("CACFP Pre-K", "CACFP Pre-K"),
    ("CACFP Adults", "CACFP Adults"),
]

# Plate Portion Choices
PLATE_PORTION_CHOICES = [
    ("Protein", "Protein"),
    ("Vegetable", "Vegetable"),
    ("Fruit", "Fruit"),
    ("Grain", "Grain"),
    ("Dairy", "Dairy"),
]

# Added function to validate allowed image formats
def validate_image_extension(value):
    ext = os.path.splitext(value.name)[1].lower()  # Get the file extension
    allowed_extensions = ['.jpg', '.jpeg', '.png', '.webp', '.avif']
    if ext not in allowed_extensions:
        raise ValidationError(f"Unsupported file format: {ext}. Allowed formats: {', '.join(allowed_extensions)}")

class MenuItem(models.Model):
    plate_name = models.CharField(max_length=255)

    meal_type = models.CharField(
        max_length=50,
        choices=MEAL_TYPE_CHOICES
    )

    lunch_programs = models.ManyToManyField("LunchProgram", blank=True)
    plate_portions = models.ManyToManyField("PlatePortion", blank=True)

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


class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    menu_item = models.ForeignKey(MenuItem, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)  # ✅ Quantity field added

    class Meta:
        unique_together = ('user', 'menu_item')

    def __str__(self):
        return f'{self.quantity} x {self.menu_item.plate_name} in {self.user.username}\'s cart'

from django.db import models
from django.contrib.auth.models import User

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
    menu_items = models.ManyToManyField("MenuItem")  # ✅ Order contains multiple menu items
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="Pending")
    created_at = models.DateTimeField(auto_now_add=True)
    quantity = models.PositiveIntegerField(default=1)  # ✅ Store the quantity
    
    class Meta:
        verbose_name = "Customer Orders"
        verbose_name_plural = "Customer Orders"

    def __str__(self):
        return f"Order {self.id} - {self.user.username} ({self.status})"

class OrderItem(models.Model):
    order = models.ForeignKey(UserOrder, on_delete=models.CASCADE, related_name="order_items")
    menu_item = models.ForeignKey("MenuItem", on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    menu_item_date = models.DateField(null=True, blank=True, default=None)  # ✅ Ensure it's nullable

    def __str__(self):
        return f"{self.quantity}x {self.menu_item.plate_name} in Order #{self.order.id} (Date: {self.menu_item_date})"




# Lunch Program Model (For Multiple Selection)
class LunchProgram(models.Model):
    name = models.CharField(
        max_length=50,
        choices=LUNCH_PROGRAM_CHOICES,
        unique=True
    )

    def __str__(self):
        return self.name

# Plate Portion Model (For Multiple Selection)
class PlatePortion(models.Model):
    name = models.CharField(
        max_length=50,
        choices=PLATE_PORTION_CHOICES,
        unique=True
    )

    def __str__(self):
        return self.name

# Date Availability Model
class MenuDate(models.Model):
    date = models.DateField(unique=True)  # Each date is stored here

    def __str__(self):
        return self.date.strftime("%Y-%m-%d")  # Format date as YYYY-MM-DD



