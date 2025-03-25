from django.shortcuts import redirect
from django.conf import settings
from .models import School

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


class AutoSelectSchoolMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.user.is_authenticated:
            if "selected_school" not in request.session:
                schools = School.objects.filter(users=request.user)
                if schools.exists():
                    request.session["selected_school"] = schools.first().id
        return self.get_response(request)