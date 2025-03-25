import requests
import logging
import json
from datetime import datetime
from django.conf import settings

logger = logging.getLogger(__name__)

class SendPulseAPI:
    def __init__(self):
        self.api_url = settings.SENDPULSE_API_URL
        self.api_user_id = settings.SENDPULSE_API_USER_ID
        self.api_secret = settings.SENDPULSE_API_SECRET
        self.token = self.get_access_token()

    def get_access_token(self):
        url = f"{self.api_url}/oauth/access_token"
        data = {
            "grant_type": "client_credentials",
            "client_id": self.api_user_id,
            "client_secret": self.api_secret
        }
        response = requests.post(url, json=data)
        return response.json().get("access_token")

    def send_email(self, to_email, reset_link, first_name=None):
        url = f"{self.api_url}/smtp/emails"
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }

        greeting = f"Hi {first_name}," if first_name else "Hello,"

        html_body = f"""
            <html>
            <body style="font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px;">
                <div style="max-width: 600px; margin: auto; background: #fff; border-radius: 8px; padding: 30px; text-align: center;">
                    <img src="https://freshstart.pythonanywhere.com/static/images/fresh_start_logo.avif" alt="Logo" style="max-width: 200px; margin-bottom: 20px;">
                    <img src="https://freshstart.pythonanywhere.com/static/images/Screenshot%202025-03-20%20182439.png" alt="Spilled Glass" style="max-width: 100px; margin-bottom: 20px;">
                    <h2>Forgot your password?</h2>
                    <p style="font-size: 16px;">{greeting}</p>
                    <p style="font-size: 15px; color: #333;">
                        That's okay, it happens to the best of us. Just click the button below to reset your password.
                        If you didn't request this, feel free to ignore this email.
                    </p>
                    <a href="{reset_link}" style="display: inline-block; margin-top: 20px; background: #72bc0a; color: white; padding: 12px 24px; border-radius: 5px; text-decoration: none;">Reset My Password</a>
                    <p style="margin-top: 30px; font-size: 12px; color: #999;">© {datetime.now().year}, FreshStart Healthy Meals</p>
                </div>
            </body>
            </html>
        """

        payload = {
            "email": {
                "subject": "Reset Your Password",
                "from": {
                    "name": "FreshStart Support",
                    "email": settings.SENDPULSE_SENDER_EMAIL
                },
                "to": [{"email": to_email}],
                "body": html_body,
                "text": f"""Hi there,

                    We received a request to reset your password for your FreshStart account.

                    To reset your password, click the link below:

                    {reset_link}

                    If you didn’t request a password reset, no worries — you can safely ignore this email and your password will remain unchanged.

                    Thanks,
                    The FreshStart Support Team
                    info@digitalonbrand.com"""
            }
        }

        response = requests.post(url, headers=headers, json=payload)
        logger.error(f"📨 SendPulse API Response: {response.status_code} {response.json()}")
        return response.json()

    def send_order_notification(self, order):
        from_user = order.user
        full_name = f"{from_user.first_name} {from_user.last_name}".strip()
        subject = f"New Order - Order #{order.id} - {full_name}"

        order_items = order.order_items.select_related("menu_item").all()
        item_lines = "\n".join(
            f"- {item.menu_item.plate_name} x{item.quantity} (for {item.menu_item.available_date})"
            for item in order_items
        )

        plain_text = f"""A new order has been placed!

        Customer: {full_name}
        School: {order.school.name if order.school else "—"}
        Email: {from_user.email}

        Order ID: {order.id}
        Date: {order.created_at.strftime('%B %d, %Y')}

        Items:
        {item_lines}

        View order in admin: https://freshstart.pythonanywhere.com/admin/food_order_api/userorder/{order.id}/
        """

        payload = {
            "email": {
                "subject": subject,
                "from": {
                    "name": "FreshStart System",
                    "email": settings.SENDPULSE_SENDER_EMAIL
                },
                "to": [{"email": "phillip@digitalonbrand.com"}],
                "text": plain_text
            }
        }

        url = f"{self.api_url}/smtp/emails"
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json"
        }

        response = requests.post(url, headers=headers, json=payload)
        logger.error(f"📨 Order notification email response: {response.status_code} {response.json()}")
        return response.json()
