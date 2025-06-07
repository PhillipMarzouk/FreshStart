import os
import time
from django.core.management.base import BaseCommand
from django.conf import settings

EXPORT_DIR = os.path.join(settings.BASE_DIR, "exported_files")
EXPIRATION_SECONDS = 7 * 24 * 60 * 60   #1 week

class Command(BaseCommand):
    help = "Deletes exported Excel files older than 7 days"

    def handle(self, *args, **kwargs):
        now = time.time()
        if not os.path.exists(EXPORT_DIR):
            return

        for filename in os.listdir(EXPORT_DIR):
            path = os.path.join(EXPORT_DIR, filename)
            if os.path.isfile(path):
                file_age = now - os.path.getmtime(path)
                if file_age > EXPIRATION_SECONDS:
                    os.remove(path)
                    self.stdout.write(f"Deleted old export: {filename}")
