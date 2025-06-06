import json
from django import forms
from django.contrib.auth import get_user_model
from django.utils.safestring import mark_safe
from django.core.exceptions import ValidationError
from .models import LunchProgram, DeliverySchedule, School, OrderItem, DAYS_OF_WEEK
from datetime import date
from django.db.models import Case, When, Value, IntegerField


class UpdateProfileForm(forms.ModelForm):
    class Meta:
        model = get_user_model()  # Use CustomUser if applicable
        fields = ["first_name", "last_name", "email"]  # Add any necessary fields


class MilkDistributionWidget(forms.Widget):
    template_name = None  # Not using a separate template

    MILK_OPTIONS = [
        "1% Milk",
        "Fat-Free Chocolate Milk",
        "Fat-Free White Milk",
        "Whole Milk",
        "Shelf Stable Milk",
        "Soy Milk",
    ]

    def render(self, name, value, attrs=None, renderer=None):
        if isinstance(value, str):
            try:
                value = json.loads(value)
            except json.JSONDecodeError:
                value = {}
        value = value or {}

        html = '<div style="display: flex; gap: 30px;">'

        for milk in self.MILK_OPTIONS:
            percent = value.get(milk, 0)
            html += f'''
                <div style="display: flex; flex-direction: column; align-items: left;">
                    <label style="margin-bottom: 4px;">{milk}</label>
                    <input type="number" name="{name}[{milk}]" value="{percent}" min="0" max="100" style="width: 60px; text-align: left;">
                </div>
            '''

        html += '</div>'
        return mark_safe(html)


    def value_from_datadict(self, data, files, name):
        return {
            milk: int(data.get(f"{name}[{milk}]" or 0))
            for milk in self.MILK_OPTIONS
            if f"{name}[{milk}]" in data
        }


class MilkDistributionField(forms.Field):
    def to_python(self, value):
        if isinstance(value, dict):
            return value
        try:
            return json.loads(value) if value else {}
        except json.JSONDecodeError:
            raise ValidationError("Invalid JSON format for milk distribution.")

    def validate(self, value):
        super().validate(value)
        if not isinstance(value, dict):
            raise ValidationError("Milk distribution must be a dictionary.")
        if sum(value.values()) != 100:
            raise ValidationError("Milk percentages must add up to 100%.")




class SchoolAdminForm(forms.ModelForm):
    breakfast_milk_distribution = MilkDistributionField(widget=MilkDistributionWidget(), required=False, label="Breakfast")
    cereal_milk_distribution = MilkDistributionField(widget=MilkDistributionWidget(), required=False, label="Cereal")
    lunch_milk_distribution = MilkDistributionField(widget=MilkDistributionWidget(), required=False, label="Lunch")
    snack_milk_distribution = MilkDistributionField(widget=MilkDistributionWidget(), required=False, label="Snack")
    therapeutic_milk_distribution = MilkDistributionField(widget=MilkDistributionWidget(), required=False, label="Therapeutic")

    lunch_programs = forms.ModelMultipleChoiceField(
        queryset=LunchProgram.objects.all(),
        widget=forms.CheckboxSelectMultiple
    )

    WEEKDAY_ORDER = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

    delivery_schedule = forms.ModelMultipleChoiceField(
        queryset=DeliverySchedule.objects.all().order_by(
            Case(
                *[When(name=day, then=Value(pos)) for pos, day in enumerate(WEEKDAY_ORDER)],
                output_field=IntegerField()
            )
        ),
        widget=forms.CheckboxSelectMultiple
    )


    pizza_days = forms.MultipleChoiceField(
        choices=DAYS_OF_WEEK,
        widget=forms.CheckboxSelectMultiple,
        required=False,
        label="Pizza Days"
    )
    family_style_days = forms.MultipleChoiceField(
        choices=DAYS_OF_WEEK,
        widget=forms.CheckboxSelectMultiple,
        required=False,
        label="Family Style Days"
    )

    class Meta:
        model = School
        fields = "__all__"

    def clean(self):
        return super().clean()  # Just call the base method, no extra logic here





class OrderItemInlineForm(forms.ModelForm):
    class Meta:
        model = OrderItem
        fields = "__all__"
        widgets = {
            "menu_item_date": forms.DateInput(attrs={"type": "date", "min": date.today().isoformat()}),
            "delivery_date": forms.DateInput(attrs={"type": "date", "min": date.today().isoformat()}),
        }
