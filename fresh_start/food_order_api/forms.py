from django import forms
from django.contrib.auth.models import User

class UpdateProfileForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ["first_name", "last_name", "email"]
        labels = {
            "first_name": "First Name",
            "last_name": "Last Name",
            "email": "Email Address",
        }