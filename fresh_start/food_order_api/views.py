import calendar
import io
import sys
import json

from reportlab.lib.pagesizes import landscape, letter
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
from django.contrib.staticfiles import finders
from reportlab.lib import colors
from textwrap import wrap
from django.conf import settings

from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes
from django.contrib.sites.shortcuts import get_current_site
from utils.sendpulse import SendPulseAPI

from rest_framework import generics, permissions, status, serializers, viewsets
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from .models import MenuItem, UserOrder
from .serializers import UserOrderSerializer
from django.utils.dateparse import parse_date
from django.utils.timezone import now, localdate
from django.http import JsonResponse, HttpResponse

from rest_framework import generics, permissions, status, serializers
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.decorators import api_view
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework import status

from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib import messages
from .serializers import UserOrderSerializer, MenuItemSerializer, CartSerializer, UserSerializer

from django.contrib.auth import logout
from django.contrib.auth import update_session_auth_hash, logout, authenticate, login
from django.contrib.auth.forms import PasswordChangeForm
from django.contrib.auth import authenticate, login
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.views import View
from rest_framework.views import View
from .models import (
    Cart, UserOrder, MenuItem,
    MenuDate, LunchProgram, OrderItem,
    CustomerSupportProfile, UserProfile,
    CustomUser, School
)
from food_order_api.models import School
from datetime import date, timedelta, datetime
from .forms import UpdateProfileForm
from collections import defaultdict




class RegisterView(APIView):
    serializer_class = UserSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            return Response({
                "refresh": str(refresh),
                "access": str(refresh.access_token)
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CartAddAPIView(generics.CreateAPIView):
    serializer_class = CartSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def create(self, request, *args, **kwargs):
        menu_item_id = request.data.get("menu_item_id")  # ✅ Expect `menu_item_id`
        if not menu_item_id:
            return Response({"error": "No menu item selected"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            menu_item = MenuItem.objects.get(id=menu_item_id)
        except MenuItem.DoesNotExist:
            return Response({"error": "Menu item not found"}, status=status.HTTP_404_NOT_FOUND)

        # ✅ Add menu item to cart
        Cart.objects.create(user=request.user, menu_item=menu_item)
        return Response({"success": "Item added to cart"}, status=status.HTTP_201_CREATED)

class UserOrderListAPIView(generics.ListAPIView):
    serializer_class = UserOrderSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_queryset(self):
        return UserOrder.objects.filter(user=self.request.user)
class OrderCreateAPIView(generics.CreateAPIView):
    queryset = UserOrder.objects.all()
    serializer_class = UserOrderSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def perform_create(self, serializer):
        user_cart = Cart.objects.filter(user=self.request.user)
        items = [cart.food_item for cart in user_cart]
        serializer.save(user=self.request.user, items=items)
        user_cart.delete()

#
# ---------------
# ***************
#
# NEW CODE
#
# ***************
# ---------------
@method_decorator(login_required, name="dispatch")

#Food Items View (test page)
class FoodItemsView(View):
    def get(self, request):
        # Fetch food items from the database
        food_items = FoodItem.objects.all()
        return render(request, 'food_items.html', {'food_items': food_items})

#Homepage View

class MonthlyMenuView(View):
    def get(self, request):
        user = request.user
        selected_date_str = request.GET.get("date", "")
        selected_date = parse_date(selected_date_str) or date.today()

        # ✅ Ensure a school is selected
        school_id = request.session.get("selected_school")
        if not school_id:
            schools = School.objects.filter(users=request.user)
            if schools.exists():
                school_id = schools.first().id
                request.session["selected_school"] = school_id
            else:
                messages.error(request, "No schools available.")
                return redirect("dashboard")


        school = get_object_or_404(School, id=school_id, users=user)
        school_lunch_programs = school.lunch_programs.all()

        # ✅ Build date range for full calendar month (Mon–Fri)
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:
            last_day += timedelta(days=1)

        month_dates = [first_day + timedelta(days=i) for i in range((last_day - first_day).days + 1)]
        menu_items_by_date = {}

        for single_date in month_dates:
            menu_items = MenuItem.objects.filter(
                available_date=single_date,
                lunch_programs__in=school_lunch_programs
            ).distinct()
            menu_items_by_date[single_date] = menu_items

        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(request, "menu.html", {
            "menu_items_by_date": menu_items_by_date,
            "selected_month": selected_date,
            "prev_month": prev_month,
            "next_month": next_month,
        })


import logging
logger = logging.getLogger(__name__)

def send_password_reset_email(request):
    if request.method == "POST":
        email = request.POST.get("email")
        user = User.objects.filter(email=email).first()

        if user:
            token = default_token_generator.make_token(user)
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            domain = get_current_site(request).domain
            reset_link = f"https://{domain}/password-reset-confirm/{uid}/{token}/"
            first_name = user.first_name if user.first_name else None

            logger.error(f"🔍 DEBUG to_email: {email}")
            logger.error(f"🔗 DEBUG reset_link: {reset_link}")

            sendpulse = SendPulseAPI()
            response = sendpulse.send_email(email, reset_link, first_name)

            logger.error(f"📨 SendPulse response: {response}")
        else:
            logger.error(f"❌ No user found with email: {email}")

        return redirect("login")

    return render(request, "registration/password_reset_form.html")

# Login Page
def login_view(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect("/")  # Redirect to homepage after login
        else:
            return render(request, "login.html", {"error": "Invalid username or password"})
    return render(request, "login.html")

# New Order Page
class NewOrderView(View):
    def get(self, request):
        user = request.user
        selected_date_str = request.GET.get("date", "")
        selected_date = parse_date(selected_date_str) or date.today()

        # ✅ Ensure school is selected
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

        # ✅ Build calendar range (Mon–Fri)
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:
            last_day += timedelta(days=1)

        month_dates = [first_day + timedelta(days=i) for i in range((last_day - first_day).days + 1)]
        menu_items_by_date = {}

        for single_date in month_dates:
            menu_items = MenuItem.objects.filter(
                available_date=single_date,
                lunch_programs__in=school_lunch_programs
            ).distinct()
            menu_items_by_date[single_date] = menu_items

        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(request, "new_order.html", {
            "menu_items_by_date": menu_items_by_date,
            "selected_month": selected_date,
            "prev_month": prev_month,
            "next_month": next_month,
        })




    def post(self, request):
        selected_items = request.POST.getlist("menu_items[]")  # ✅ Use getlist()
        quantities = request.POST.getlist("quantities[]")  # ✅ Use getlist()

                # ✅ Ensure valid data before processing
        if not selected_items or not quantities or len(selected_items) != len(quantities):
            messages.error(request, "No valid items selected. Please choose at least one item.")
            return redirect("new_order")

        for item_id, quantity in zip(selected_items, quantities):
            try:
                menu_item = MenuItem.objects.get(id=int(item_id.strip()))
                quantity = int(quantity)

                if quantity > 0:  # ✅ Only add items with valid quantity
                    cart_item, created = Cart.objects.get_or_create(
                        user=request.user,
                        menu_item=menu_item,
                        defaults={"quantity": quantity}
                    )

                    if not created:
                        cart_item.quantity += quantity
                        cart_item.save()
                    else:
                        print(f"✅ Added {quantity}x {menu_item.plate_name} to cart.")

            except (MenuItem.DoesNotExist, ValueError) as e:
                print(f"❌ Error processing item {item_id}: {e}")
                continue  # ✅ Skip invalid items

        print("✅ Order processing complete. Redirecting to cart.")
        return redirect("cart")




    def validate_meal(self, selected_items):
        """Ensure selected meal includes at least one of each required portion."""
        required_categories = {"Protein", "Vegetable", "Fruit", "Grain", "Dairy"}
        selected_categories = set()

        for item_id in selected_items:
            try:
                menu_item = MenuItem.objects.get(id=int(item_id))
                selected_categories.update(menu_item.plate_portions.values_list("name", flat=True))
            except MenuItem.DoesNotExist:
                continue  # Skip if menu item doesn't exist

        return required_categories.issubset(selected_categories)


class MenuItemViewSet(viewsets.ModelViewSet):
    serializer_class = MenuItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        try:
            lunch_program = user.userprofile.lunch_program
            if lunch_program:
                return MenuItem.objects.filter(lunch_programs=lunch_program)
        except UserProfile.DoesNotExist:
            return MenuItem.objects.none()  # No lunch program assigned

        return MenuItem.objects.all()

# Cart Page
class CartView(View):
    def get(self, request):
        cart_items = Cart.objects.filter(user=request.user).select_related("menu_item").order_by("menu_item__available_date")

        # ✅ Group cart items by available_date
        grouped_cart_items = {}
        for cart in cart_items:
            order_date = cart.menu_item.available_date
            if order_date not in grouped_cart_items:
                grouped_cart_items[order_date] = []
            grouped_cart_items[order_date].append(cart)

        return render(request, "cart.html", {
            "grouped_cart_items": grouped_cart_items  # ✅ Pass grouped items to template
        })

    def post(self, request):
        for key, value in request.POST.items():
            if key.startswith('quantity_'):
                cart_item_id = key.split('_')[1]
                try:
                    cart_item = Cart.objects.get(id=cart_item_id, user=request.user)
                    cart_item.quantity = int(value)
                    cart_item.save()
                except Cart.DoesNotExist:
                    continue
        return redirect("cart")

def remove_from_cart(request, cart_id):
    cart_item = get_object_or_404(Cart, id=cart_id, user=request.user)
    cart_item.delete()
    return redirect("cart")

def update_cart(request):
    """Handles quantity updates or item removal in the cart."""
    if request.method == "POST":
        item_id = request.POST.get("item_id")
        new_quantity = request.POST.get("quantity")

        cart_item = get_object_or_404(Cart, id=item_id, user=request.user)

        if int(new_quantity) > 0:
            cart_item.quantity = int(new_quantity)
            cart_item.save()
        else:
            cart_item.delete()  # Remove if quantity is set to 0

        return JsonResponse({"success": True, "quantity": cart_item.quantity if cart_item else 0})

    return JsonResponse({"success": False, "error": "Invalid request"})

#Checkout
class CheckoutView(View):
    def post(self, request):
        school_id = request.session.get("selected_school")
        if not school_id:
            messages.error(request, "Please select a school before placing an order.")
            return redirect("cart")

        school = get_object_or_404(School, id=school_id, users=request.user)

        cart_items = Cart.objects.filter(user=request.user)
        if not cart_items.exists():
            messages.error(request, "Your cart is empty. Please add items before checking out.")
            return redirect("cart")

        order = UserOrder.objects.create(user=request.user, school=school, status="Pending")

        for cart_item in cart_items:
            OrderItem.objects.create(
                order=order,
                menu_item=cart_item.menu_item,
                quantity=cart_item.quantity,
                menu_item_date=cart_item.menu_item.available_date
            )

        cart_items.delete()
        SendPulseAPI().send_order_notification(order)

        messages.success(request, f"Your order for {school.name} has been placed and is now pending.")
        return redirect("past_orders")


class PastOrdersView(View):
    def get(self, request):
        school_id = request.session.get("selected_school")
        if not school_id:
            messages.error(request, "Please select a school to view past orders.")
            return redirect("home")

        school = get_object_or_404(School, id=school_id, users=request.user)
        past_orders = UserOrder.objects.filter(user=request.user, school=school).order_by("-created_at")

        orders_with_dates = {}

        for order in past_orders:
            order_date = order.created_at.date()

            if order.id not in orders_with_dates:
                orders_with_dates[order.id] = {
                    "order": order,
                    "order_date": order_date,
                    "delivery_groups": {}
                }

            for order_item in order.order_items.all():
                consumption_date = order_item.menu_item_date  # ✅ Use saved menu_item_date
                delivery_date = order_item.delivery_date or consumption_date  # ✅ Fallback if missing

                # ✅ Organize data by delivery → consumption
                if delivery_date not in orders_with_dates[order.id]["delivery_groups"]:
                    orders_with_dates[order.id]["delivery_groups"][delivery_date] = {}

                if consumption_date not in orders_with_dates[order.id]["delivery_groups"][delivery_date]:
                    orders_with_dates[order.id]["delivery_groups"][delivery_date][consumption_date] = []

                orders_with_dates[order.id]["delivery_groups"][delivery_date][consumption_date].append({
                    "order": order,
                    "order_date": order_date,
                    "delivery_date": delivery_date,
                    "consumption_date": consumption_date,
                    "order_item": order_item,
                })

        return render(request, "past_orders.html", {
            "orders_with_dates": orders_with_dates,
            "selected_school": school
        })





def menu_item_clone_view(request, pk):
    """Clone an existing menu item."""
    original = get_object_or_404(MenuItem, pk=pk)
    clone = MenuItem.objects.create(
        plate_name=f"{original.plate_name} (Copy)",
        meal_type=original.meal_type,
        is_new=True,  # Mark cloned items as new
        available_date=original.available_date,
        image=original.image
    )
    return redirect("admin:food_order_api_menuitem_change", clone.pk)



class HomeView(View):
    def get(self, request):
        user = request.user
        is_admin = user.is_staff

        # Get recent orders for customers
        if not is_admin:
            active_orders = UserOrder.objects.filter(user=user, status__in=["Pending", "Order Received", "Paid"]).order_by("-created_at")
            past_orders = UserOrder.objects.filter(user=user, status__in=["Manufactured", "Shipped", "Delivered"]).order_by("-created_at")[:5]
        else:
            # Admin view: Show orders grouped by status
            order_status_counts = {
                status: UserOrder.objects.filter(status=status).count()
                for status, _ in UserOrder.STATUS_CHOICES
            }
            active_orders = UserOrder.objects.filter(status="Pending").order_by("-created_at")[:5]  # Show latest 5 pending

        return render(request, "dashboard.html", {
            "user": user,
            "is_admin": is_admin,
            "active_orders": active_orders if not is_admin else None,
            "past_orders": past_orders if not is_admin else None,
            "order_status_counts": order_status_counts if is_admin else None
        })

class AccountView(View):
    def get(self, request):
        """Display the user account page."""
        return render(request, "account.html", {"user": request.user})


class CustomerSupportProfileView(View):
    def get(self, request):
        support_profiles = CustomerSupportProfile.objects.all()
        return render(request, "support_profiles.html", {"support_profiles": support_profiles})


class UpdateProfileView(View):
    def get(self, request):
        form = UpdateProfileForm(instance=request.user)
        return render(request, "account.html", {"form": form})

    def post(self, request):
        form = UpdateProfileForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect("account")
        return render(request, "account.html", {"form": form})


class ChangePasswordView(View):
    def post(self, request):
        form = PasswordChangeForm(request.user, request.POST)
        if form.is_valid():
            user = form.save()
            update_session_auth_hash(request, user)  # Keep the user logged in
            return redirect("account")
        return render(request, "account.html", {"password_form": form})


def logout_view(request):
    logout(request)
    return redirect("login")  # Redirect to the login page after logout



def get_week_range(year, month):
    """Find the Monday of the first week and the Friday of the last week of the selected month."""
    first_day = datetime(year, month, 1)
    last_day = datetime(year, month, calendar.monthrange(year, month)[1])

    # Move first_day to the Monday of its week
    first_monday = first_day - timedelta(days=first_day.weekday())

    # Move last_day to the Friday of its week
    last_friday = last_day + timedelta(days=(4 - last_day.weekday()) % 7)

    return first_monday, last_friday

@login_required
def set_selected_school(request):
    if request.method == "POST":
        school_id = request.POST.get("school_id") or request.POST.get("selected_school")  # ⬅ handle both keys
        try:
            print(f"🔍 Attempting to set school ID: {school_id} for user: {request.user}")
            school = School.objects.get(id=school_id, users=request.user)
            request.session["selected_school"] = school.id
            return JsonResponse({"success": True, "selected_school": school.name})
        except School.DoesNotExist:
            print("❌ School not found or not linked to this user")
            return JsonResponse({"success": False, "error": "Invalid school selection."}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request method."}, status=400)


@login_required
def set_selected_school(request):
    if request.method == "POST":
        school_id = request.POST.get("school_id") or request.POST.get("selected_school")
        try:
            school = School.objects.get(id=school_id, users=request.user)
            request.session["selected_school"] = school.id
            return JsonResponse({"success": True, "selected_school": school.name})
        except School.DoesNotExist:
            return JsonResponse({"success": False, "error": "Invalid school selection."}, status=400)

    # ✅ Fallback: If no school is selected, auto-select the first one (for non-POST requests)
    if not request.session.get("selected_school"):
        schools = School.objects.filter(users=request.user)
        if schools.exists():
            request.session["selected_school"] = schools.first().id

    return JsonResponse({"success": False, "error": "Invalid request method."}, status=400)


@login_required
def export_menu_calendar(request):
    """Generates a weekly PDF calendar with menu items based on consumption date for the selected school."""
    # ✅ Get selected school from session
    school_id = request.session.get("selected_school")
    if not school_id:
        messages.error(request, "Please select a school before exporting the menu.")
        return redirect("past_orders")

    school = get_object_or_404(School, id=school_id, users=request.user)

    # ✅ Get selected month and year from request
    month_year = request.GET.get("month")
    if not month_year:
        return HttpResponse("Invalid month selection.", status=400)

    try:
        selected_date = datetime.strptime(month_year, "%Y-%m")
        year = selected_date.year
        month = selected_date.month
    except ValueError:
        return HttpResponse("Invalid date format. Expected YYYY-MM.", status=400)

    # ✅ Get first Monday and last Friday of the selected month
    def get_week_range(year, month):
        first_day = datetime(year, month, 1)
        last_day = datetime(year, month, calendar.monthrange(year, month)[1])

        first_monday = first_day - timedelta(days=first_day.weekday())
        last_friday = last_day + timedelta(days=(4 - last_day.weekday()) % 7)

        return first_monday.date(), last_friday.date()

    first_monday, last_friday = get_week_range(year, month)

    # ✅ Fetch orders **ONLY** for the selected school
    orders = UserOrder.objects.filter(
        user=request.user,
        school=school,  # ✅ Filter by school
        order_items__menu_item__available_date__range=[first_monday, last_friday]
    ).distinct()

    # ✅ Organize menu items by consumption date
    menu_by_date = defaultdict(list)
    for order in orders:
        for item in order.order_items.all():
            consumption_date = item.menu_item.available_date
            if first_monday <= consumption_date <= last_friday:
                menu_by_date[consumption_date].append(item.menu_item.plate_name)

    # ✅ Get customer support details
    profile = getattr(request.user, "profile", None)
    customer_rep = getattr(profile, "customer_support_rep", None)

    rep_name = getattr(customer_rep, "name", "Customer Support")
    rep_email = getattr(customer_rep, "email", "support@fshealthymeals.com")
    rep_phone = getattr(customer_rep, "phone", "818-797-5881")

    # ✅ Prepare PDF
    buffer = io.BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=landscape(letter))
    pdf.setTitle(f"Menu_Calendar_{month}_{year}")

    # ✅ Define layout parameters
    freshstart_green = (114 / 255, 188 / 255, 10 / 255)  # #72bc0a (Company Green)
    start_x = 60  # Adjusted for equal left/right margins
    start_y = 550  # Higher to fit content better
    cell_width = 140  # Adjusted for proper margin balance
    base_cell_height = 400  # Fixed height per cell
    line_height = 12  # Line spacing

    current_date = first_monday

    while current_date <= last_friday:
        pdf.setFont("Helvetica-Bold", 16)
        pdf.drawString(start_x, 570, f"Menu Calendar - {calendar.month_name[month]} {year} (Week of {current_date.strftime('%B %d')})")

        y_offset = start_y - 30  # Adjusted spacing for first row

        # ✅ Fill in menu items per day (without weekday headers)
        for i in range(5):  # Monday to Friday
            x_pos = start_x + (i * cell_width)
            y_pos = y_offset - base_cell_height

            # ✅ Format: "Mar 03 - Monday"
            date_label = f"{current_date.strftime('%b %d')} - {current_date.strftime('%A')}"

            pdf.rect(x_pos, y_pos, cell_width, base_cell_height, stroke=1, fill=0)  # Fixed height
            pdf.setFont("Helvetica-Bold", 11)
            pdf.drawString(x_pos + 5, y_pos + base_cell_height - 15, date_label)

            # ✅ Wrap text for menu items with separator lines
            pdf.setFont("Helvetica", 10)
            line_y = y_pos + base_cell_height - 35
            items = menu_by_date.get(current_date, [])

            for item in items:
                wrapped_text = wrap(item, width=18)  # Wrap text properly
                for line in wrapped_text:
                    if line_y > y_pos + 15:  # Prevent overflow
                        pdf.drawString(x_pos + 5, line_y, line)
                        line_y -= line_height

                # ✅ Draw a full-width separator line after each menu item
                if line_y > y_pos + 15:
                    pdf.line(x_pos + 5, line_y, x_pos + cell_width - 5, line_y)
                    line_y -= 10  # Small space before next item

            # ✅ Move to the next weekday
            current_date += timedelta(days=1)

            # ✅ Skip weekends
            while current_date.weekday() >= 5:  # 5 = Saturday, 6 = Sunday
                current_date += timedelta(days=1)

        # ✅ Footer section (full width)
        footer_y = 30
        pdf.setFillColorRGB(*freshstart_green)
        pdf.rect(50, footer_y, 700, 40, fill=1, stroke=0)

        # ✅ Add customer support details in white text
        pdf.setFillColorRGB(1, 1, 1)
        pdf.setFont("Helvetica", 9)
        pdf.drawString(60, footer_y + 25, f"{rep_name} | {rep_email} | {rep_phone}")

        pdf.showPage()  # ✅ Ensures new page starts correctly

    # ✅ Save the PDF
    pdf.save()
    buffer.seek(0)

    # ✅ Serve PDF inline (opens in a new tab instead of downloading)
    response = HttpResponse(buffer, content_type="application/pdf")
    response["Content-Disposition"] = f'inline; filename="Menu_Calendar_{month}_{year}.pdf"'
    return response
