from django.shortcuts import redirect
from django.conf import settings

EXEMPT_PATHS = [
    settings.LOGIN_URL,
    "/password-reset/",
    "/password-reset-confirm/",
    "/reset/",  # optional, in case Django uses this
    "/static/",  # for CSS/JS/images
]

class LoginRequiredMiddleware:
    """Middleware to redirect unauthenticated users to the login page."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        path = request.path

        # Allow public paths
        if any(path.startswith(p) for p in EXEMPT_PATHS):
            return self.get_response(request)

        if not request.user.is_authenticated:
            return redirect(settings.LOGIN_URL)

        return self.get_response(request)