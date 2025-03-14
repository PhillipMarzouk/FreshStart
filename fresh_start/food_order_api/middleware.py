from django.shortcuts import redirect
from django.conf import settings

class LoginRequiredMiddleware:
    """Middleware to redirect unauthenticated users to the login page."""
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Allow access to the login page
        if request.path.startswith(settings.LOGIN_URL):
            return self.get_response(request)

        # Redirect if the user is not authenticated
        if not request.user.is_authenticated:
            return redirect(settings.LOGIN_URL)

        return self.get_response(request)
