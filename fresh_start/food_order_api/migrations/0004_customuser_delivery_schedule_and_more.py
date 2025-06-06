# Generated by Django 4.2 on 2025-04-14 05:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("food_order_api", "0003_remove_customuser_delivery_schedule_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="customuser",
            name="delivery_schedule",
            field=models.ManyToManyField(
                blank=True,
                related_name="custom_users",
                to="food_order_api.deliveryschedule",
            ),
        ),
        migrations.RemoveField(
            model_name="school",
            name="delivery_schedule",
        ),
        migrations.AddField(
            model_name="school",
            name="delivery_schedule",
            field=models.ManyToManyField(
                blank=True, to="food_order_api.deliveryschedule"
            ),
        ),
    ]
