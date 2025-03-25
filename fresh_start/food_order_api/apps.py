from django.apps import AppConfig
from django.contrib.auth.apps import AuthConfig


class FoodOrderApiConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'food_order_api'
    verbose_name = 'Menu & Order Management'

class MyAuthConfig(AuthConfig):
    name = 'django.contrib.auth'         # Must match the existing auth app
    verbose_name = "User Management"

