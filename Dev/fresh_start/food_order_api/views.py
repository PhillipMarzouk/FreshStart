"""
views.py - Main views and API endpoints for FreshStart food ordering system.
Uses Django, Django REST Framework, and ReportLab for PDF generation.
"""


import calendar
import io
import json
import math
import copy
from datetime import date, timedelta, datetime
from collections import defaultdict
from textwrap import wrap

import pandas as pd
from reportlab.lib.pagesizes import landscape, letter
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
from reportlab.lib import colors

from django.conf import settings
from django.contrib import messages
from django.contrib.auth import get_user_model, authenticate, login, logout, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import PasswordChangeForm
from django.contrib.auth.tokens import default_token_generator
from django.contrib.sites.shortcuts import get_current_site
from django.http import JsonResponse, HttpResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.utils.dateparse import parse_date
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.utils.timezone import now, localdate
from django.contrib.staticfiles import finders
from django.utils.decorators import method_decorator
from django.views import View

from rest_framework import generics, permissions, status, viewsets, serializers
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.decorators import api_view
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.views import APIView

from utils.sendpulse import SendPulseAPI

from .models import (
    Cart,
    CustomerSupportProfile,
    LunchProgram,
    MenuDate,
    MenuItem,
    MilkTypeImage,
    OrderItem,
    School,
    UserOrder,
    UserProfile,
    CustomUser,
)
from .serializers import (
    CartSerializer,
    MenuItemSerializer,
    UserOrderSerializer,
    UserSerializer,
)
from .forms import UpdateProfileForm

# Use Django's get_user_model to reference CustomUser rather than auth.User
User = get_user_model()


# --------------------------------------------------------------------------------
# User Registration Endpoint
# --------------------------------------------------------------------------------
class RegisterView(APIView):
    serializer_class = UserSerializer

    def post(self, request):
        """
        Registers a new user. Expects JSON payload matching UserSerializer.
        Returns JWT tokens upon successful creation.
        """
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            return Response(
                {"refresh": str(refresh), "access": str(refresh.access_token)},
                status=status.HTTP_201_CREATED,
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# --------------------------------------------------------------------------------
# Cart API: Add a MenuItem to the Cart with an override date
# --------------------------------------------------------------------------------
class CartAddAPIView(generics.CreateAPIView):
    serializer_class = CartSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def create(self, request, *args, **kwargs):
        """
        Expects JSON: { "menu_item_id": <int>, "menu_item_date": "YYYY-MM-DD" }
        Validates inputs, fetches MenuItem, parses date, then creates a Cart entry.
        """
        menu_item_id = request.data.get("menu_item_id")
        menu_item_date_str = request.data.get("menu_item_date")

        if not menu_item_id:
            return Response(
                {"error": "No menu item selected"}, status=status.HTTP_400_BAD_REQUEST
            )

        if not menu_item_date_str:
            return Response(
                {"error": "No menu item date provided"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Fetch the MenuItem by ID
        try:
            menu_item = MenuItem.objects.get(id=menu_item_id)
        except MenuItem.DoesNotExist:
            return Response(
                {"error": "Menu item not found"}, status=status.HTTP_404_NOT_FOUND
            )

        # Parse the provided date string
        try:
            menu_item_date = datetime.strptime(menu_item_date_str, "%Y-%m-%d").date()
        except ValueError:
            return Response(
                {"error": "Invalid date format. Use YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Create the Cart record linking user, menu item, and override date
        Cart.objects.create(user=request.user, menu_item=menu_item, date_override=menu_item_date)
        return Response({"success": "Item added to cart"}, status=status.HTTP_201_CREATED)


# --------------------------------------------------------------------------------
# User Orders API: List and Create endpoints
# --------------------------------------------------------------------------------
class UserOrderListAPIView(generics.ListAPIView):
    serializer_class = UserOrderSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        """
        Returns all UserOrder objects belonging to the authenticated user.
        """
        return UserOrder.objects.filter(user=self.request.user)


class OrderCreateAPIView(generics.CreateAPIView):
    queryset = UserOrder.objects.all()
    serializer_class = UserOrderSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def perform_create(self, serializer):
        """
        On order creation, gather all Cart items for this user as 'items',
        save the order, then clear the cart.
        """
        user_cart = Cart.objects.filter(user=self.request.user)
        items = [cart.food_item for cart in user_cart]
        serializer.save(user=self.request.user, items=items)
        user_cart.delete()


# --------------------------------------------------------------------------------
# Food Items View (Test page) - requires login
# --------------------------------------------------------------------------------
@method_decorator(login_required, name="dispatch")
class FoodItemsView(View):
    def get(self, request):
        """
        Simple view to render all FoodItem objects (for testing purposes).
        """
        food_items = FoodItem.objects.all()
        return render(request, "food_items.html", {"food_items": food_items})


# --------------------------------------------------------------------------------
# Monthly Menu View: Display calendar grid of MenuItems for a school
# --------------------------------------------------------------------------------
class MonthlyMenuView(View):
    def get(self, request):
        """
        Renders a month grid (Mon-Fri) of menu items available for the selected school.
        Combines the school’s lunch programs, handles “Cold Only” filtering,
        and always includes field trip items for each day.
        """
        user = request.user

        # Determine which month to display, defaulting to today
        selected_date_str = request.GET.get("date", "")
        selected_date = parse_date(selected_date_str) or date.today()

        # Ensure the user has a selected_school in session, else pick the first
        school_id = request.session.get("selected_school")
        if not school_id:
            schools = School.objects.filter(users=request.user)
            if schools.exists():
                school_id = schools.first().id
                request.session["selected_school"] = school_id
            else:
                messages.error(request, "No schools available.")
                return redirect("dashboard")

        # Fetch the School object; 404 if not linked to user
        school = get_object_or_404(School, id=school_id, users=user)
        school_lunch_programs = school.lunch_programs.all()

        # Build a date range covering the full month’s Mondays through Fridays
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:  # Move to Monday
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:  # Move to Friday
            last_day += timedelta(days=1)

        month_dates = [
            first_day + timedelta(days=i)
            for i in range((last_day - first_day).days + 1)
        ]
        menu_items_by_date = {}

        # For each date, fetch items matching that date and school program
        for single_date in month_dates:
            menu_items = list(
                MenuItem.objects.filter(
                    available_date=single_date,
                    lunch_programs__in=school_lunch_programs,
                ).distinct()
            )

            # If the school is “Cold Only”, filter out hot meal types
            if school.delivery_type == "Cold Only":
                allowed_meal_types = [
                    "Breakfast",
                    "Breakfast Cereal",
                    "Cold Meal",
                    "Cold Pastas",
                    "Cold Vegetarian",
                    "Daily Salad",
                    "Snack",
                    "Vegan",
                    "Therapeutic",
                    "Milk",
                ]
                menu_items = [item for item in menu_items if item.meal_type in allowed_meal_types]

            # Always append field trip items for display, faking the available_date
            field_trip_items = MenuItem.objects.filter(
                plate_name__in=["FIELD TRIP STANDARD", "FIELD TRIP VEGETARIAN"]
            )
            for item in field_trip_items:
                item.available_date = single_date
                menu_items.append(item)

            menu_items_by_date[single_date] = menu_items

        # Calculate previous and next month for navigation buttons
        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(
            request,
            "menu.html",
            {
                "menu_items_by_date": menu_items_by_date,
                "selected_month": selected_date,
                "prev_month": prev_month,
                "next_month": next_month,
            },
        )


# --------------------------------------------------------------------------------
# Password Reset via SendPulse - uses CustomUser model
# --------------------------------------------------------------------------------
import logging

logger = logging.getLogger(__name__)


def send_password_reset_email(request):
    """
    Renders password reset form on GET.
    On POST, looks up CustomUser by email, creates a token & uid, and sends an email
    via SendPulseAPI. Redirects to 'login' afterward.
    """
    if request.method == "POST":
        email = request.POST.get("email")
        user = User.objects.filter(email=email).first()

        if user:
            token = default_token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            domain = get_current_site(request).domain
            reset_link = f"https://{domain}/password-reset-confirm/{uid}/{token}/"
            first_name = user.first_name if user.first_name else None

            logger.debug(f"🔍 Reset email to: {email}")
            logger.debug(f"🔗 Reset link: {reset_link}")

            sendpulse = SendPulseAPI()
            response = sendpulse.send_email(email, reset_link, first_name)

            logger.debug(f"📨 SendPulse response: {response}")
        else:
            logger.debug(f"❌ No user found with email: {email}")

        return redirect("login")

    # Render the default Django password reset form template
    return render(request, "registration/password_reset_form.html")


# --------------------------------------------------------------------------------
# Login View
# --------------------------------------------------------------------------------
def login_view(request):
    """
    Renders login page. On POST, authenticates credentials and redirects to home.
    """
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect("/")
        else:
            # If authentication fails, re-render login template with error
            return render(request, "login.html", {"error": "Invalid username or password"})
    return render(request, "login.html")


# --------------------------------------------------------------------------------
# New Order View: Display calendar and process new orders
# --------------------------------------------------------------------------------
class NewOrderView(View):
    def get(self, request):
        """
        GET: Builds a Mon-Fri calendar for the selected month, similar to MonthlyMenuView,
        but for the “new order” screen: fetches menu items for each date, includes field trip items.
        """
        user = request.user
        selected_date_str = request.GET.get("date", "")
        selected_date = parse_date(selected_date_str) or date.today()

        # Ensure a school is selected, else pick first linked school
        school_id = request.session.get("selected_school")
        if not school_id:
            schools = School.objects.filter(users=request.user)
            if schools.exists():
                school_id = schools.first().id
                request.session["selected_school"] = school_id
            else:
                messages.error(request, "No schools available.")
                return redirect("dashboard")

        school = get_object_or_404(School, id=school_id, users=request.user)
        school_lunch_programs = school.lunch_programs.all()

        # Build calendar date range (Mon-Fri)
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:
            last_day += timedelta(days=1)

        month_dates = [
            first_day + timedelta(days=i)
            for i in range((last_day - first_day).days + 1)
        ]
        menu_items_by_date = {}

        # Allowed meal types if school is Cold Only
        allowed_meal_types = [
            "Breakfast",
            "Breakfast Cereal",
            "Cold Meal",
            "Cold Pastas",
            "Cold Vegetarian",
            "Daily Salad",
            "Snack",
            "Vegan",
            "Therapeutic",
            "Milk",
        ]

        for single_date in month_dates:
            menu_items = list(
                MenuItem.objects.filter(
                    available_date=single_date,
                    lunch_programs__in=school_lunch_programs,
                ).distinct()
            )

            if school.delivery_type == "Cold Only":
                menu_items = [item for item in menu_items if item.meal_type in allowed_meal_types]

            # Always include field trip items each day
            field_trip_items = MenuItem.objects.filter(is_field_trip=True)
            for item in field_trip_items:
                item.available_date = single_date
                menu_items.append(item)

            menu_items_by_date[single_date] = menu_items

        # Calculate navigation months
        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(
            request,
            "new_order.html",
            {
                "menu_items_by_date": menu_items_by_date,
                "selected_month": selected_date,
                "prev_month": prev_month,
                "next_month": next_month,
            },
        )

    def post(self, request):
        """
        POST: Processes form submission of selected menu items and quantities.
        Expects POST lists 'menu_items[]' as "<id>|YYYY-MM-DD" and 'quantities[]'.
        Creates/updates Cart entries accordingly.
        """
        selected_items = request.POST.getlist("menu_items[]")
        quantities = request.POST.getlist("quantities[]")

        # Validate that both lists exist and match lengths
        if not selected_items or not quantities or len(selected_items) != len(quantities):
            messages.error(request, "No valid items selected. Please choose at least one item.")
            return redirect("new_order")

        for item_id, quantity in zip(selected_items, quantities):
            try:
                quantity = int(quantity)
                parts = item_id.split("|")
                if len(parts) != 2:
                    print(f"⚠️ Skipping invalid format: {item_id}")
                    continue

                menu_item_id = int(parts[0])
                menu_item_date = datetime.strptime(parts[1], "%Y-%m-%d").date()
                menu_item = MenuItem.objects.get(id=menu_item_id)

                if quantity > 0:
                    cart_item, created = Cart.objects.get_or_create(
                        user=request.user,
                        menu_item=menu_item,
                        date_override=menu_item_date,
                        defaults={"quantity": quantity},
                    )
                    if not created:
                        # If already in cart, increment quantity
                        cart_item.quantity += quantity
                        cart_item.save()

            except Exception as e:
                # Log any parsing or lookup errors, but continue processing next item
                print(f"❌ Error processing cart item {item_id}: {e}")

        print("✅ Order processing complete. Redirecting to cart.")
        return redirect("cart")

    def validate_meal(self, selected_items):
        """
        Utility to ensure that a selected meal bundle includes at least one of each portion:
        Protein, Vegetable, Fruit, Grain, Dairy.
        Returns True if all categories are present.
        """
        required_categories = {"Protein", "Vegetable", "Fruit", "Grain", "Dairy"}
        selected_categories = set()

        for item_id in selected_items:
            try:
                menu_item = MenuItem.objects.get(id=int(item_id))
                selected_categories.update(menu_item.plate_portions.values_list("name", flat=True))
            except MenuItem.DoesNotExist:
                continue

        return required_categories.issubset(selected_categories)


# --------------------------------------------------------------------------------
# MenuItem API ViewSet: Filter by user's lunch program if assigned
# --------------------------------------------------------------------------------
class MenuItemViewSet(viewsets.ModelViewSet):
    serializer_class = MenuItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """
        If the user has a linked UserProfile with a lunch_program, filter MenuItems accordingly.
        Otherwise return all MenuItems.
        """
        user = self.request.user
        try:
            lunch_program = user.userprofile.lunch_program
            if lunch_program:
                return MenuItem.objects.filter(lunch_programs=lunch_program)
        except UserProfile.DoesNotExist:
            return MenuItem.objects.none()

        return MenuItem.objects.all()


# --------------------------------------------------------------------------------
# Cart Page: Display and update cart contents
# --------------------------------------------------------------------------------
class CartView(View):
    def get(self, request):
        """
        GET: Fetch all Cart items for the user, group them by date_override or item available_date,
        and render the 'cart.html' template.
        """
        cart_items = (
            Cart.objects.filter(user=request.user)
            .select_related("menu_item")
            .order_by("menu_item__available_date")
        )
        # Fetch milk images to display alongside milk items
        milk_images = {m.name: m.image.url for m in MilkTypeImage.objects.all()}

        grouped_cart_items = {}
        for cart in cart_items:
            order_date = cart.date_override or cart.menu_item.available_date
            grouped_cart_items.setdefault(order_date, []).append(cart)

        return render(
            request,
            "cart.html",
            {
                "grouped_cart_items": grouped_cart_items,
                "milk_images": milk_images,
                "notes": request.session.get("cart_notes", ""),
            },
        )

    def post(self, request):
        """
        POST: Handles quantity updates via form fields named 'quantity_<cart_id>'.
        Also saves any 'notes' field to session.
        """
        for key, value in request.POST.items():
            if key.startswith("quantity_"):
                cart_item_id = key.split("_")[1]
                try:
                    cart_item = Cart.objects.get(id=cart_item_id, user=request.user)
                    cart_item.quantity = int(value)
                    cart_item.save()
                except Cart.DoesNotExist:
                    continue

        # Persist any notes entered by the user
        request.session["cart_notes"] = request.POST.get("notes", "")
        return redirect("cart")


def remove_from_cart(request, cart_id):
    """
    Utility view to remove a specific Cart item by its ID and redirect back to the cart page.
    """
    cart_item = get_object_or_404(Cart, id=cart_id, user=request.user)
    cart_item.delete()
    return redirect("cart")


def update_cart(request):
    """
    AJAX endpoint to update quantity of a single Cart item.
    Expects POST with 'item_id' and 'quantity'. Returns JSON indicating success.
    """
    if request.method == "POST":
        item_id = request.POST.get("item_id")
        new_quantity = request.POST.get("quantity")
        cart_item = get_object_or_404(Cart, id=item_id, user=request.user)

        if int(new_quantity) > 0:
            cart_item.quantity = int(new_quantity)
            cart_item.save()
        else:
            cart_item.delete()

        return JsonResponse({"success": True, "quantity": cart_item.quantity if cart_item else 0})

    return JsonResponse({"success": False, "error": "Invalid request"})


# --------------------------------------------------------------------------------
# Checkout View: Create UserOrder, calculate milk & fruit items, send notifications
# --------------------------------------------------------------------------------
class CheckoutView(View):
    def post(self, request):
        """
        Processes checkout: ensures school is selected, cart is not empty.
        Creates a new UserOrder, calculates corresponding milk and fruit OrderItems,
        deletes the cart, sends notifications, and redirects.
        """
        # Validate that a school is selected
        school_id = request.session.get("selected_school")
        if not school_id:
            messages.error(request, "Please select a school before placing an order.")
            return redirect("cart")

        # Fetch school
        school = get_object_or_404(School, id=school_id, users=request.user)

        # 1) Grab the cart queryset *and* snapshot it into a list
        cart_qs    = Cart.objects.filter(user=request.user)
        cart_items = list(cart_qs)                     # <-- fixed list copy

        if not cart_items:
            messages.error(request, "Your cart is empty. Please add items before checking out.")
            return redirect("cart")

        notes = request.POST.get("notes", "").strip() or request.session.get("cart_notes", "")
        order = UserOrder.objects.create(
            user=request.user, school=school, status="Pending", notes=notes
        )

        # Map meal types → milk distributions
        meal_type_to_field = {
            "Breakfast":       school.breakfast_milk_distribution,
            "Breakfast Cereal":school.cereal_milk_distribution,
            "Hot Meal":        school.lunch_milk_distribution,
            "Hot Vegetarian":  school.lunch_milk_distribution,
            "Cold Meal":       school.lunch_milk_distribution,
            "Cold Pastas":     school.lunch_milk_distribution,
            "Cold Vegetarian": school.lunch_milk_distribution,
            "Daily Salad":     school.lunch_milk_distribution,
            "Snack":           school.snack_milk_distribution,
            "Therapeutic":     school.therapeutic_milk_distribution,
            "Vegan":           {"Soy Milk": 100},
        }

        # 2) MILK CALCULATION
        milk_by_date = defaultdict(lambda: defaultdict(float))
        for item in cart_items:
            dist = meal_type_to_field.get(item.menu_item.meal_type)
            if not dist:
                continue
            dt = item.date_override or item.menu_item.available_date
            for milk_name, pct in dist.items():
                milk_by_date[dt][milk_name] += (pct / 100) * item.quantity

        # Use math.ceil to avoid dropping sub-1 quantities
        for dt, totals in milk_by_date.items():
            for milk_name, qty in totals.items():
                final_qty = math.ceil(qty)             # <-- always round up
                if final_qty:
                    milk_item, _ = MenuItem.objects.get_or_create(
                        plate_name=milk_name,
                        defaults={"meal_type": "Milk"}
                    )
                    OrderItem.objects.create(
                        order=order,
                        menu_item=milk_item,
                        quantity=final_qty,
                        menu_item_date=dt
                    )

        # 3) ORIGINAL CART ITEMS
        for cart_item in cart_items:
            dt = cart_item.date_override or cart_item.menu_item.available_date
            OrderItem.objects.create(
                order=order,
                menu_item=cart_item.menu_item,
                quantity=cart_item.quantity,
                menu_item_date=dt
            )

        # 4) FRUIT CALCULATION
        fruit_counts = defaultdict(int)
        for item in cart_items:
            if item.menu_item.meal_type != "Snack":
                dt = item.date_override or item.menu_item.available_date
                fruit_counts[dt] += item.quantity

        fruit_item, _ = MenuItem.objects.get_or_create(
            plate_name="Fruit",
            defaults={"meal_type": "Fruit"}
        )
        for dt, qty in fruit_counts.items():
            if qty:
                OrderItem.objects.create(
                    order=order,
                    menu_item=fruit_item,
                    quantity=qty,
                    menu_item_date=dt
                )

        # 5) Now clear the cart and finish
        cart_qs.delete()                              # <-- delete via the queryset
        SendPulseAPI().send_order_notification(order)
        SendPulseAPI().send_order_confirmation_to_customer(order)
        if "cart_notes" in request.session:
            del request.session["cart_notes"]

        messages.success(request, f"Your order for {school.name} has been placed and is now pending.")
        return redirect("past_orders")



# --------------------------------------------------------------------------------
# Past Orders View: Display past orders grouped by delivery and consumption dates
# --------------------------------------------------------------------------------
class PastOrdersView(View):
    def get(self, request):
        """
        Renders a list of past UserOrder objects for the selected school.
        Groups order items by delivery_date, then by consumption_date,
        and passes milk images for display.
        """
        school_id = request.session.get("selected_school")
        if not school_id:
            messages.error(request, "Please select a school to view past orders.")
            return redirect("dashboard")

        school = get_object_or_404(School, id=school_id, users=request.user)
        past_orders = (
            UserOrder.objects.filter(user=request.user, school=school)
            .order_by("-created_at")
        )
        # Preload milk images
        milk_images = {m.name: m.image.url for m in MilkTypeImage.objects.all()}

        orders_with_dates = {}

        for order in past_orders:
            order_date = order.created_at.date()
            if order.id not in orders_with_dates:
                orders_with_dates[order.id] = {
                    "order": order,
                    "order_date": order_date,
                    "delivery_groups": {},
                }

            # Iterate through each OrderItem in this order
            for order_item in order.order_items.all():
                consumption_date = order_item.menu_item_date
                # If the system stored a separate delivery_date, use it; otherwise fallback
                delivery_date = order_item.delivery_date or consumption_date

                # Initialize nested dicts if not present
                if delivery_date not in orders_with_dates[order.id]["delivery_groups"]:
                    orders_with_dates[order.id]["delivery_groups"][delivery_date] = {}

                if consumption_date not in orders_with_dates[order.id]["delivery_groups"][
                    delivery_date
                ]:
                    orders_with_dates[order.id]["delivery_groups"][delivery_date][
                        consumption_date
                    ] = []

                # Append the order item details for the template
                orders_with_dates[order.id]["delivery_groups"][delivery_date][
                    consumption_date
                ].append(
                    {
                        "order": order,
                        "order_date": order_date,
                        "delivery_date": delivery_date,
                        "consumption_date": consumption_date,
                        "order_item": order_item,
                    }
                )

        return render(
            request,
            "past_orders.html",
            {
                "orders_with_dates": orders_with_dates,
                "selected_school": school,
                "milk_images": milk_images,
            },
        )


# --------------------------------------------------------------------------------
# Utility to clone an existing MenuItem (admin convenience)
# --------------------------------------------------------------------------------
def menu_item_clone_view(request, pk):
    """
    Clones a MenuItem by primary key. Appends "(Copy)" to the plate_name.
    Redirects to the admin change page for the new object.
    """
    original = get_object_or_404(MenuItem, pk=pk)
    clone = MenuItem.objects.create(
        plate_name=f"{original.plate_name} (Copy)",
        meal_type=original.meal_type,
        is_new=True,
        available_date=original.available_date,
        image=original.image,
    )
    return redirect("admin:food_order_api_menuitem_change", clone.pk)


# --------------------------------------------------------------------------------
# Home/Dashboard View
# --------------------------------------------------------------------------------
class HomeView(View):
    def get(self, request):
        """
        Renders the dashboard. If user is not staff, show their active/past orders.
        If staff, show counts of orders by status and a preview of pending orders.
        """
        user = request.user
        is_admin = user.is_staff

        if not is_admin:
            active_orders = UserOrder.objects.filter(
                user=user, status__in=["Pending", "Order Received", "Paid"]
            ).order_by("-created_at")
            past_orders = UserOrder.objects.filter(
                user=user, status__in=["Manufactured", "Shipped", "Delivered"]
            ).order_by("-created_at")[:5]
        else:
            # Build a dict of counts for each status
            order_status_counts = {
                status: UserOrder.objects.filter(status=status).count()
                for status, _ in UserOrder.STATUS_CHOICES
            }
            active_orders = (
                UserOrder.objects.filter(status="Pending")
                .order_by("-created_at")[:5]
            )

        return render(
            request,
            "dashboard.html",
            {
                "user": user,
                "is_admin": is_admin,
                "active_orders": active_orders if not is_admin else None,
                "past_orders": past_orders if not is_admin else None,
                "order_status_counts": order_status_counts if is_admin else None,
            },
        )


# --------------------------------------------------------------------------------
# Account & Profile Views
# --------------------------------------------------------------------------------
class AccountView(View):
    def get(self, request):
        """
        Renders the user's account page, using request.user for details.
        """
        return render(request, "account.html", {"user": request.user})


class CustomerSupportProfileView(View):
    def get(self, request):
        """
        Lists all CustomerSupportProfile objects for display.
        """
        support_profiles = CustomerSupportProfile.objects.all()
        return render(request, "support_profiles.html", {"support_profiles": support_profiles})


class UpdateProfileView(View):
    def get(self, request):
        """
        Renders a form to update the authenticated user's profile.
        """
        form = UpdateProfileForm(instance=request.user)
        return render(request, "account.html", {"form": form})

    def post(self, request):
        """
        Processes profile updates via UpdateProfileForm.
        """
        form = UpdateProfileForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect("account")
        return render(request, "account.html", {"form": form})


class ChangePasswordView(View):
    def post(self, request):
        """
        Handles password change via Django's PasswordChangeForm.
        Preserves login session after successful change.
        """
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            user = form.save()
            update_session_auth_hash(request, user)
            return redirect("account")
        return render(request, "account.html", {"password_form": form})


def logout_view(request):
    """
    Logs out the current user and redirects to login page.
    """
    logout(request)
    return redirect("login")


# --------------------------------------------------------------------------------
# Helper: Calculate first Monday and last Friday of a month
# --------------------------------------------------------------------------------
def get_week_range(year, month):
    """
    Returns a tuple (first_monday, last_friday) datetime objects for the given year/month.
    Expands to the full weeks (Mon-Fri) that encompass the month’s days.
    """
    first_day = datetime(year, month, 1)
    last_day = datetime(year, month, calendar.monthrange(year, month)[1])
    first_monday = first_day - timedelta(days=first_day.weekday())
    last_friday = last_day + timedelta(days=(4 - last_day.weekday()) % 7)
    return first_monday, last_friday


# --------------------------------------------------------------------------------
# Set Selected School (AJAX & fallback logic)
# --------------------------------------------------------------------------------
@login_required
def set_selected_school(request):
    """
    POST: Accepts 'school_id' or 'selected_school' and stores in session if valid for user.
    GET (or others): If no school is in session, automatically select first linked school.
    Returns JSON indicating success/failure.
    """
    if request.method == "POST":
        school_id = request.POST.get("school_id") or request.POST.get("selected_school")
        try:
            school = School.objects.get(id=school_id, users=request.user)
            request.session["selected_school"] = school.id
            return JsonResponse({"success": True, "selected_school": school.name})
        except School.DoesNotExist:
            return JsonResponse({"success": False, "error": "Invalid school selection."}, status=400)

    # Fallback: auto-select first school if none in session
    if not request.session.get("selected_school"):
        schools = School.objects.filter(users=request.user)
        if schools.exists():
            request.session["selected_school"] = schools.first().id

    return JsonResponse({"success": False, "error": "Invalid request method."}, status=400)


# --------------------------------------------------------------------------------
# Export Menu Calendar to PDF (opens inline)
# --------------------------------------------------------------------------------
@login_required
def export_menu_calendar(request):
    """
    Generates a weekly PDF menu calendar for the selected month and school.
    - Fetches all ordered menu items (excluding milk) in the date range.
    - Injects Pizza on the school's pizza_days.
    - Draws a grid (Mon-Fri), writes date header + menu items per cell.
    - Adds footer with customer support rep details.
    - Returns PDF inline (opens in new tab).
    """
    school_id = request.session.get("selected_school")
    if not school_id:
        messages.error(request, "Please select a school before exporting the menu.")
        return redirect("past_orders")

    school = get_object_or_404(School, id=school_id, users=request.user)

    month_year = request.GET.get("month")
    if not month_year:
        return HttpResponse("Invalid month selection.", status=400)

    # Parse "YYYY-MM" format
    try:
        selected_date = datetime.strptime(month_year, "%Y-%m")
        year = selected_date.year
        month = selected_date.month
    except ValueError:
        return HttpResponse("Invalid date format. Expected YYYY-MM.", status=400)

    # Helper to get first Monday / last Friday as dates
    def get_week_range(year, month):
        first_day = datetime(year, month, 1)
        last_day = datetime(year, month, calendar.monthrange(year, month)[1])
        first_monday = first_day - timedelta(days=first_day.weekday())
        last_friday = last_day + timedelta(days=(4 - last_day.weekday()) % 7)
        return first_monday.date(), last_friday.date()

    first_monday, last_friday = get_week_range(year, month)

    # Build a dict: { consumption_date: [plate_name, ...] }
    menu_by_date = defaultdict(list)

    # Fetch all orders (excluding milk) for this user+school in date range
    orders = (
        UserOrder.objects.filter(
            user=request.user,
            school=school,
            order_items__menu_item_date__range=[first_monday, last_friday],
        )
        .prefetch_related("order_items__menu_item")
        .distinct()
    )

    for order in orders:
        order_items = order.order_items.filter(
            menu_item_date__range=[first_monday, last_friday]
        ).exclude(menu_item__meal_type="Milk")

        for item in order_items:
            menu_by_date[item.menu_item_date].append(item.menu_item.plate_name)

    # If the school has pizza_days set, insert "Pizza" at top for those weekdays
    if school.pizza_days:
        current = first_monday
        while current <= last_friday:
            weekday_key = current.strftime("%a").lower()[:3]  # e.g. "Mon" → "mon"
            if weekday_key in school.pizza_days:
                menu_by_date[current].insert(0, "Pizza")
            current += timedelta(days=1)

    # Fetch customer support rep info from user's profile if linked
    profile = getattr(request.user, "profile", None)
    customer_rep = getattr(profile, "customer_support_rep", None)

    rep_name = getattr(customer_rep, "name", "Customer Support")
    rep_email = getattr(customer_rep, "email", "support@fshealthymeals.com")
    rep_phone = getattr(customer_rep, "phone", "818-797-5881")

    # Prepare PDF buffer and canvas
    buffer = io.BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=landscape(letter))
    pdf.setTitle(f"Menu_Calendar_{month}_{year}")

    # Layout parameters
    freshstart_green = (114 / 255, 188 / 255, 10 / 255)  # #72bc0a
    start_x = 60
    start_y = 550
    cell_width = 140
    base_cell_height = 400
    line_height = 12

    current_date = first_monday

    # Loop through each week (Mon-Fri), producing a new page per week
    while current_date <= last_friday:
        # Header line with month, year, and week-of date
        pdf.setFont("Helvetica-Bold", 16)
        pdf.drawString(
            start_x,
            570,
            f"Menu Calendar - {calendar.month_name[month]} {year} (Week of {current_date.strftime('%B %d')})",
        )

        y_offset = start_y - 30

        # Draw five columns (Mon-Fri)
        for i in range(5):
            x_pos = start_x + (i * cell_width)
            y_pos = y_offset - base_cell_height

            # Date label inside cell
            date_label = f"{current_date.strftime('%b %d')} - {current_date.strftime('%A')}"
            pdf.rect(x_pos, y_pos, cell_width, base_cell_height, stroke=1, fill=0)
            pdf.setFont("Helvetica-Bold", 11)
            pdf.drawString(x_pos + 5, y_pos + base_cell_height - 15, date_label)

            # List menu items, wrapping text if needed
            pdf.setFont("Helvetica", 10)
            line_y = y_pos + base_cell_height - 35
            items = menu_by_date.get(current_date, [])

            for item in items:
                wrapped_text = wrap(item, width=18)
                for line in wrapped_text:
                    if line_y > y_pos + 15:
                        pdf.drawString(x_pos + 5, line_y, line)
                        line_y -= line_height

                # Draw separator after each menu item
                if line_y > y_pos + 15:
                    pdf.line(x_pos + 5, line_y, x_pos + cell_width - 5, line_y)
                    line_y -= 10

            # Advance to next date, skipping weekends
            current_date += timedelta(days=1)
            while current_date.weekday() >= 5:
                current_date += timedelta(days=1)

        # Footer with customer support info on a green background
        footer_y = 30
        pdf.setFillColorRGB(*freshstart_green)
        pdf.rect(50, footer_y, 700, 40, fill=1, stroke=0)

        pdf.setFillColorRGB(1, 1, 1)
        pdf.setFont("Helvetica", 9)
        pdf.drawString(
            60, footer_y + 25, f"{rep_name} | {rep_email} | {rep_phone}"
        )

        pdf.showPage()  # Start new page for next week

    # Finalize and return PDF buffer
    pdf.save()
    buffer.seek(0)

    response = HttpResponse(buffer, content_type="application/pdf")
    response["Content-Disposition"] = f'inline; filename="Menu_Calendar_{month}_{year}.pdf"'
    return response
