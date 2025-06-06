# Generated by Django 4.2 on 2025-04-13 01:43

from django.conf import settings
import django.contrib.auth.models
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import food_order_api.models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ("auth", "0012_alter_user_first_name_max_length"),
    ]

    operations = [
        migrations.CreateModel(
            name="CustomUser",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("password", models.CharField(max_length=128, verbose_name="password")),
                (
                    "last_login",
                    models.DateTimeField(
                        blank=True, null=True, verbose_name="last login"
                    ),
                ),
                (
                    "is_superuser",
                    models.BooleanField(
                        default=False,
                        help_text="Designates that this user has all permissions without explicitly assigning them.",
                        verbose_name="superuser status",
                    ),
                ),
                (
                    "username",
                    models.CharField(
                        error_messages={
                            "unique": "A user with that username already exists."
                        },
                        help_text="Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.",
                        max_length=150,
                        unique=True,
                        validators=[
                            django.contrib.auth.validators.UnicodeUsernameValidator()
                        ],
                        verbose_name="username",
                    ),
                ),
                (
                    "first_name",
                    models.CharField(
                        blank=True, max_length=150, verbose_name="first name"
                    ),
                ),
                (
                    "last_name",
                    models.CharField(
                        blank=True, max_length=150, verbose_name="last name"
                    ),
                ),
                (
                    "email",
                    models.EmailField(
                        blank=True, max_length=254, verbose_name="email address"
                    ),
                ),
                (
                    "is_staff",
                    models.BooleanField(
                        default=False,
                        help_text="Designates whether the user can log into this admin site.",
                        verbose_name="staff status",
                    ),
                ),
                (
                    "is_active",
                    models.BooleanField(
                        default=True,
                        help_text="Designates whether this user should be treated as active. Unselect this instead of deleting accounts.",
                        verbose_name="active",
                    ),
                ),
                (
                    "date_joined",
                    models.DateTimeField(
                        default=django.utils.timezone.now, verbose_name="date joined"
                    ),
                ),
            ],
            managers=[
                ("objects", django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name="CustomerSupportProfile",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("first_name", models.CharField(max_length=100)),
                ("last_name", models.CharField(max_length=100)),
                ("email", models.EmailField(max_length=254, unique=True)),
                ("phone_number", models.CharField(max_length=15)),
                ("extension", models.CharField(blank=True, max_length=10, null=True)),
                (
                    "photo",
                    models.ImageField(
                        blank=True, null=True, upload_to="support_profiles/"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="DeliverySchedule",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "name",
                    models.CharField(
                        choices=[
                            ("Monday", "Monday"),
                            ("Tuesday", "Tuesday"),
                            ("Wednesday", "Wednesday"),
                            ("Thursday", "Thursday"),
                            ("Friday", "Friday"),
                        ],
                        max_length=20,
                        unique=True,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="FoodType",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name="LunchProgram",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name="MenuDate",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("date", models.DateField(unique=True)),
            ],
        ),
        migrations.CreateModel(
            name="MenuItem",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("plate_name", models.CharField(max_length=255)),
                (
                    "meal_type",
                    models.CharField(
                        choices=[
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
                        ],
                        max_length=50,
                    ),
                ),
                ("is_field_trip", models.BooleanField(default=False)),
                ("is_new", models.BooleanField(default=False)),
                ("available_date", models.DateField(blank=True, null=True)),
                (
                    "image",
                    models.ImageField(
                        blank=True,
                        null=True,
                        upload_to="menu_images/",
                        validators=[food_order_api.models.validate_image_extension],
                    ),
                ),
                (
                    "lunch_programs",
                    models.ManyToManyField(
                        blank=True, to="food_order_api.lunchprogram"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MilkTypeImage",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=100, unique=True)),
                ("image", models.ImageField(upload_to="milk_images/")),
            ],
        ),
        migrations.CreateModel(
            name="PlatePortion",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=50, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name="School",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=255, unique=True)),
                (
                    "breakfast_milk_distribution",
                    models.JSONField(blank=True, default=dict),
                ),
                (
                    "cereal_milk_distribution",
                    models.JSONField(blank=True, default=dict),
                ),
                ("lunch_milk_distribution", models.JSONField(blank=True, default=dict)),
                ("snack_milk_distribution", models.JSONField(blank=True, default=dict)),
                ("vegan_milk_distribution", models.JSONField(blank=True, default=dict)),
                (
                    "therapeutic_milk_distribution",
                    models.JSONField(blank=True, default=dict),
                ),
                (
                    "grade_level",
                    models.CharField(
                        blank=True,
                        choices=[
                            ("Pre-school", "Pre-school"),
                            ("K-8", "K-8"),
                            ("9-12", "9-12"),
                            ("Adult", "Adult"),
                        ],
                        max_length=20,
                        null=True,
                    ),
                ),
                ("route_number", models.CharField(blank=True, max_length=2, null=True)),
                (
                    "delivery_type",
                    models.CharField(
                        blank=True,
                        choices=[
                            ("Ready to Serve", "Ready to Serve"),
                            ("Heat on Site", "Heat on Site"),
                        ],
                        max_length=20,
                        null=True,
                    ),
                ),
                (
                    "delivery_schedule",
                    models.ManyToManyField(
                        blank=True, to="food_order_api.deliveryschedule"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="SchoolGroup",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=255, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name="UserProfile",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("additional_notes", models.TextField(blank=True, null=True)),
                (
                    "support_rep",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.SET_NULL,
                        related_name="assigned_users",
                        to="food_order_api.customersupportprofile",
                    ),
                ),
                (
                    "user",
                    models.OneToOneField(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="profile",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="UserOrder",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "status",
                    models.CharField(
                        choices=[
                            ("Pending", "Pending"),
                            ("Nutrition Review", "Nutrition Review"),
                            ("Approved", "Approved"),
                            ("ON HOLD", "ON HOLD"),
                        ],
                        default="Pending",
                        max_length=20,
                    ),
                ),
                ("created_at", models.DateTimeField(auto_now_add=True)),
                ("quantity", models.PositiveIntegerField(default=1)),
                ("notes", models.TextField(blank=True, null=True)),
                ("staff_notes", models.TextField(blank=True, null=True)),
                ("menu_items", models.ManyToManyField(to="food_order_api.menuitem")),
                (
                    "school",
                    models.ForeignKey(
                        blank=True,
                        null=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="orders",
                        to="food_order_api.school",
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="orders",
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
            options={
                "verbose_name": "Customer Orders",
                "verbose_name_plural": "Customer Orders",
            },
        ),
        migrations.AddField(
            model_name="school",
            name="group",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name="schools",
                to="food_order_api.schoolgroup",
            ),
        ),
        migrations.AddField(
            model_name="school",
            name="lunch_programs",
            field=models.ManyToManyField(blank=True, to="food_order_api.lunchprogram"),
        ),
        migrations.AddField(
            model_name="school",
            name="users",
            field=models.ManyToManyField(
                related_name="schools", to=settings.AUTH_USER_MODEL
            ),
        ),
        migrations.CreateModel(
            name="OrderItem",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("quantity", models.PositiveIntegerField(default=1)),
                (
                    "menu_item_date",
                    models.DateField(blank=True, default=None, null=True),
                ),
                (
                    "delivery_date",
                    models.DateField(blank=True, default=None, null=True),
                ),
                (
                    "menu_item",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="food_order_api.menuitem",
                    ),
                ),
                (
                    "order",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="order_items",
                        to="food_order_api.userorder",
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="menuitem",
            name="plate_portions",
            field=models.ManyToManyField(blank=True, to="food_order_api.plateportion"),
        ),
        migrations.CreateModel(
            name="FoodItem",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("name", models.CharField(max_length=100)),
                ("price", models.DecimalField(decimal_places=2, max_digits=6)),
                (
                    "food_type",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name="food_items",
                        to="food_order_api.foodtype",
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Cart",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("quantity", models.PositiveIntegerField(default=1)),
                ("date_override", models.DateField(blank=True, null=True)),
                (
                    "menu_item",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to="food_order_api.menuitem",
                    ),
                ),
                (
                    "user",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        to=settings.AUTH_USER_MODEL,
                    ),
                ),
            ],
        ),
        migrations.AddField(
            model_name="customuser",
            name="delivery_schedule",
            field=models.ManyToManyField(
                blank=True,
                related_name="custom_users",
                to="food_order_api.deliveryschedule",
            ),
        ),
        migrations.AddField(
            model_name="customuser",
            name="groups",
            field=models.ManyToManyField(
                blank=True, related_name="customuser_set", to="auth.group"
            ),
        ),
        migrations.AddField(
            model_name="customuser",
            name="lunch_programs",
            field=models.ManyToManyField(
                blank=True,
                related_name="custom_users",
                to="food_order_api.lunchprogram",
            ),
        ),
        migrations.AddField(
            model_name="customuser",
            name="support_rep",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name="assigned_custom_users",
                to="food_order_api.customersupportprofile",
            ),
        ),
        migrations.AddField(
            model_name="customuser",
            name="user_permissions",
            field=models.ManyToManyField(
                blank=True,
                related_name="customuser_permissions_set",
                to="auth.permission",
            ),
        ),
        migrations.AddConstraint(
            model_name="cart",
            constraint=models.UniqueConstraint(
                fields=("user", "menu_item", "date_override"),
                name="unique_cart_per_day",
            ),
        ),
    ]
