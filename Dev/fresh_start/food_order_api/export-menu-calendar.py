from datetime import datetime, timedelta
import calendar
from django.http import HttpResponse
from django.shortcuts import render
from reportlab.lib.pagesizes import landscape, letter
from reportlab.pdfgen import canvas
from reportlab.lib import colors
from django.contrib.auth.decorators import login_required
from io import BytesIO
from .models import UserOrder

def get_month_range(year, month):
    """Returns the start and end dates of the selected month."""
    first_day = datetime(year, month, 1)
    last_day = datetime(year, month, calendar.monthrange(year, month)[1])
    return first_day, last_day

@login_required
def export_menu_calendar(request):
    """Generates a PDF calendar with menu items based on consumption date."""
    # Get selected month and year from request
    year = int(request.GET.get("year", datetime.now().year))
    month = int(request.GET.get("month", datetime.now().month))
    first_day, last_day = get_month_range(year, month)

    # Fetch orders within the selected month
    orders = UserOrder.objects.filter(
        user=request.user,
        order_items__menu_item__available_date__range=[first_day, last_day]
    ).distinct()

    # Organize menu items by consumption date
    menu_by_date = {}
    for order in orders:
        for item in order.order_items.all():
            consumption_date = item.menu_item.available_date
            if consumption_date not in menu_by_date:
                menu_by_date[consumption_date] = []
            menu_by_date[consumption_date].append(item.menu_item.plate_name)

    # Prepare PDF
    buffer = BytesIO()
    pdf = canvas.Canvas(buffer, pagesize=landscape(letter))
    pdf.setTitle(f"Menu_Calendar_{month}_{year}")

    # Define layout
    pdf.setFont("Helvetica-Bold", 16)
    pdf.drawString(40, 550, f"Menu Calendar - {calendar.month_name[month]} {year}")
    pdf.setFont("Helvetica", 12)
    pdf.drawString(40, 530, "For changes or updates please reach out to:")
    pdf.drawString(40, 515, "[Customer Service Rep Info]")
    
    # Draw calendar grid
    x_offset = 50
    y_offset = 400
    cell_width = 120
    cell_height = 100
    
    weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    pdf.setFont("Helvetica-Bold", 12)
    for i, day in enumerate(weekdays):
        pdf.drawString(x_offset + (i * cell_width), y_offset + 10, day)
    
    # Fill in menu items
    y_offset -= 20
    for day in range(1, last_day.day + 1):
        date = datetime(year, month, day)
        if date.strftime('%A') in weekdays:  # Skip weekends
            x_pos = x_offset + (weekdays.index(date.strftime('%A')) * cell_width)
            y_pos = y_offset - ((day // 5) * cell_height)  # Stack rows
            
            pdf.rect(x_pos, y_pos, cell_width, cell_height, stroke=1, fill=0)
            pdf.drawString(x_pos + 5, y_pos + cell_height - 15, str(day))
            
            if date in menu_by_date:
                pdf.setFont("Helvetica", 10)
                for idx, item in enumerate(menu_by_date[date]):
                    if idx < 4:  # Limit text to prevent overflow
                        pdf.drawString(x_pos + 5, y_pos + cell_height - 30 - (idx * 12), item)
                pdf.setFont("Helvetica-Bold", 12)
    
    pdf.save()
    buffer.seek(0)
    response = HttpResponse(buffer, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="Menu_Calendar_{month}_{year}.pdf"'
    return response
