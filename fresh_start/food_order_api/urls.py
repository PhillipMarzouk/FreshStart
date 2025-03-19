from django.urls import path, include
from django.contrib import admin
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import (
            CartAddAPIView, OrderCreateAPIView,
            UserOrderListAPIView, RegisterView,
            login_view, HomeView, MonthlyMenuView,
            NewOrderView, CartView, Cart, CheckoutView,
            PastOrdersView, remove_from_cart, update_cart,
            AccountView, UpdateProfileView, ChangePasswordView,
            logout_view, menu_item_clone_view
)


urlpatterns = [
    # Authentication & User Routes
    path('api-token-auth/', obtain_auth_token, name='api_token_auth'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('register/', RegisterView.as_view(), name='register'),

    # API Routes (JSON-based)
    path('api/add-to-cart/', CartAddAPIView.as_view(), name='add_to_cart'),
    path('api/place-order/', OrderCreateAPIView.as_view(), name='place_order'),
    path('api/my-orders/', UserOrderListAPIView.as_view(), name='my_orders'),

    # Template View (HTML-based)
    path("login/", login_view, name="login"),
    path("", HomeView.as_view(), name="dashboard"),
    path("menu/", MonthlyMenuView.as_view(), name="menu"),
    path("new-order/", NewOrderView.as_view(), name="new_order"),
    path("cart/", CartView.as_view(), name="cart"),
    path("cart/remove/<int:cart_id>/", remove_from_cart, name="remove_from_cart"),
    path("cart/update/", update_cart, name="update_cart"),
    path("checkout/", CheckoutView.as_view(), name="checkout"),
    path("past-orders/", PastOrdersView.as_view(), name="past_orders"),
    path("account/", AccountView.as_view(), name="account"),
    path("account/update/", UpdateProfileView.as_view(), name="update_profile"),
    path("account/change-password/", ChangePasswordView.as_view(), name="change_password"),
    path("logout/", logout_view, name="logout"),
    path("menu-item/<int:pk>/clone/", menu_item_clone_view, name="menu_item_clone"),
]
