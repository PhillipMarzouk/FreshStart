# Generated by Django 4.2 on 2025-04-17 17:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("food_order_api", "0005_school_family_style_days"),
    ]

    operations = [
        migrations.AddField(
            model_name="userprofile",
            name="email",
            field=models.EmailField(
                default="default@example.com", max_length=254, unique=True
            ),
            preserve_default=False,
        ),
    ]
