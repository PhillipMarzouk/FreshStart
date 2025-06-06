from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import FoodType, MenuItem, Cart, UserOrder


class UserSerializer(serializers.ModelSerializer):
    class Meta:
          model = get_user_model()
          fields = ('id', 'username', 'email', 'password')
          extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = get_user_model().objects.create_user(**validated_data)
        return user

class FoodTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodType
        fields = '__all__'


#class FoodItemSerializer(serializers.ModelSerializer):
#    class Meta:
#        model = FoodItem
#        fields = ['id', 'name', 'food_type', 'price']
#        read_only_fields = ['id']

#    def to_internal_value(self, data):
#        try:
#            return super().to_internal_value(data)
#        except serializers.ValidationError:
            # If the data is just an integer, assume it is an ID and construct a dictionary with just the ID field
#            if isinstance(data, int):
#                return {'id': data}
#            raise
#class FoodItemDetailSerializer(serializers.ModelSerializer):
#    food_type = serializers.SlugRelatedField(slug_field='name', queryset=FoodType.objects.all())

#    class Meta:
#        model = FoodItem
#        fields = ['id', 'name', 'food_type', 'price', 'description', 'image']

class CartSerializer(serializers.ModelSerializer):
    menu_item = serializers.PrimaryKeyRelatedField(queryset=MenuItem.objects.all())  # ✅ Replace FoodItem with MenuItem

    class Meta:
        model = Cart
        fields = ['id', 'menu_item', 'quantity']  # ✅ Update field name
        read_only_fields = ['id']

    def create(self, validated_data):
        user = self.context['request'].user
        menu_item = validated_data['menu_item']  # ✅ Use MenuItem instead
        quantity = validated_data['quantity']

        # ✅ Ensure item is unique per user
        cart, created = Cart.objects.get_or_create(user=user, menu_item=menu_item, defaults={'quantity': quantity})

        if not created:
            cart.quantity += quantity  # ✅ If already in cart, increase quantity
            cart.save()

        return cart


class UserOrderSerializer(serializers.ModelSerializer):
    items = serializers.PrimaryKeyRelatedField(many=True, queryset=MenuItem.objects.all())

    class Meta:
        model = UserOrder
        fields = ('id', 'user', 'items', 'ordered_on')

    def create(self, validated_data):
        items_data = validated_data.pop('items')
        order = UserOrder.objects.create(**validated_data)
        for item_data in items_data:
            order.items.add(item_data)
        return order

class MenuItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = MenuItem
        fields = '__all__'

