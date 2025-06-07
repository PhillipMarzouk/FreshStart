from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model

class EmailOrUsernameModelBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        UserModel = get_user_model()
        user = None

        # Try email lookup
        if username:
            try:
                user = UserModel.objects.get(email__iexact=username)
            except UserModel.DoesNotExist:
                try:
                    user = UserModel.objects.get(username__iexact=username)
                except UserModel.DoesNotExist:
                    return None

        if user and user.check_password(password) and self.user_can_authenticate(user):
            return user
        return None
