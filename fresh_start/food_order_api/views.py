from rest_framework import generics, permissions, status, serializers, viewsets
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from .models import MenuItem, UserOrder
from .serializers import UserOrderSerializer
from django.utils.dateparse import parse_date
from django.utils.timezone import now
from django.http import JsonResponse

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
from .models import Cart, UserOrder, MenuItem, MenuDate, LunchProgram, OrderItem, UserProfile
from calendar import monthrange
from datetime import date, timedelta, datetime
from .forms import UpdateProfileForm




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

        # Ensure the month starts on a Monday and ends on a Friday
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:  # Move to previous Monday if needed
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:  # Move to next Friday if needed
            last_day += timedelta(days=1)

        month_dates = [first_day + timedelta(days=i) for i in range((last_day - first_day).days + 1)]
        menu_items_by_date = {}

        # Fetch user's assigned lunch programs
        try:
            user_lunch_programs = user.userprofile.lunch_programs.all()
        except UserProfile.DoesNotExist:
            user_lunch_programs = None

        for single_date in month_dates:
            menu_items = MenuItem.objects.filter(available_date=single_date)

            # Filter by user's assigned lunch program
            if user_lunch_programs:
                menu_items = menu_items.filter(lunch_programs__in=user_lunch_programs).distinct()
            else:
                menu_items = MenuItem.objects.none()  # No lunch program assigned

            menu_items_by_date[single_date] = menu_items

        # 🔹 Corrected `prev_month` and `next_month` logic
        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(request, "menu.html", {
            "menu_items_by_date": menu_items_by_date,
            "selected_month": selected_date,
            "prev_month": prev_month,
            "next_month": next_month,  # ✅ Fixed next_month calculation
        })


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

        # Ensure month starts on a Monday and ends on a Friday
        first_day = selected_date.replace(day=1)
        while first_day.weekday() != 0:  # Move to previous Monday if needed
            first_day -= timedelta(days=1)

        last_day = selected_date.replace(day=1) + timedelta(days=32)
        last_day = last_day.replace(day=1) - timedelta(days=1)
        while last_day.weekday() != 4:  # Move to next Friday if needed
            last_day += timedelta(days=1)

        month_dates = [first_day + timedelta(days=i) for i in range((last_day - first_day).days + 1)]
        menu_items_by_date = {}

        # Fetch user's assigned lunch programs
        try:
            user_lunch_programs = user.userprofile.lunch_programs.all()
        except UserProfile.DoesNotExist:
            user_lunch_programs = None

        for single_date in month_dates:
            menu_items = MenuItem.objects.filter(available_date=single_date)

            # Filter by user's assigned lunch program
            if user_lunch_programs:
                menu_items = menu_items.filter(lunch_programs__in=user_lunch_programs).distinct()
            else:
                menu_items = MenuItem.objects.none()  # No lunch program assigned

            menu_items_by_date[single_date] = menu_items

        # 🔹 Fix: Properly calculate `prev_month` and `next_month`
        prev_month = (selected_date.replace(day=1) - timedelta(days=1)).replace(day=1)
        next_month = (selected_date.replace(day=28) + timedelta(days=4)).replace(day=1)

        return render(request, "new_order.html", {
            "menu_items_by_date": menu_items_by_date,  # ✅ Fix: Now it matches `menu.html`
            "selected_month": selected_date,
            "prev_month": prev_month,
            "next_month": next_month,  # ✅ Fixed next_month calculation
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
        cart_items = Cart.objects.filter(user=request.user)

        if not cart_items.exists():
            messages.error(request, "Your cart is empty. Please add items before checking out.")
            return redirect("cart")

        # ✅ Group items by date
        cart_by_date = {}
        for cart_item in cart_items:
            order_date = cart_item.menu_item.available_date  # ✅ Get menu item date
            if order_date not in cart_by_date:
                cart_by_date[order_date] = {"Protein": 0, "Grain": 0, "Vegetable": 0, "Fruit": 0}

            # ✅ Count items in each category
            for portion in cart_item.menu_item.plate_portions.all():
                if portion.name in cart_by_date[order_date]:
                    cart_by_date[order_date][portion.name] += 1

        # ✅ Check if each date meets the requirement
        #for order_date, portions in cart_by_date.items():
        #    if any(count == 0 for count in portions.values()):  # If any category is missing
        #        messages.error(
        #            request,
        #            f"Your order for {order_date.strftime('%B %d, %Y')} must include at least one Protein, Grain, Vegetable, and Fruit."
        #        )
        #        return redirect("cart")

        # ✅ Create an order
        order = UserOrder.objects.create(user=request.user, status="Pending")

        for cart_item in cart_items:
            # ✅ Ensure menu_item_date is stored correctly
            menu_item_date = cart_item.menu_item.available_date if cart_item.menu_item.available_date else None

            OrderItem.objects.create(
                order=order,
                menu_item=cart_item.menu_item,
                quantity=cart_item.quantity,
                menu_item_date=menu_item_date  # ✅ Save the date in OrderItem
            )

        # ✅ Clear the cart
        cart_items.delete()

        messages.success(request, "Your order has been placed and is now pending.")
        return redirect("past_orders")


class PastOrdersView(View):
    def get(self, request):
        past_orders = UserOrder.objects.filter(user=request.user).order_by("-created_at")

        return render(request, "past_orders.html", {
            "past_orders": past_orders
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
        return render(request, "account.html", {"user": request.user})

class UpdateProfileView(View):
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
    return redirect('login')  # Redirect to the login page after logout