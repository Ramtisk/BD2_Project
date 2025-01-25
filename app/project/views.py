from datetime import datetime
from django.shortcuts import render, get_object_or_404, redirect
from django.http import JsonResponse, HttpResponseBadRequest
from .models import AppLogs, PlanDevice, DevicesType, Address, Device, Discount, Payment, Plan, PlanSubscription, SubcriptionVisit, Subscription, TecnicalVisit
from .forms import (
    ItemFormPlanDevice, ItemFormSubscription, ItemFormDevicesType, 
    ItemFormAddress, ItemFormDevice, ItemFormDiscount, ItemFormPayment, 
    ItemFormPlan, ItemFormPlanSubscription, ItemFormSubcriptionVisit, ItemFormTecnicalVisit
)
import json

from .functions import (get_clientes_recentes,contar_clientes,calculate_monthly_profit, calculate_total_profit,get_visitas_tecnicas)


def log_action(action_type, table, action, description):
    AppLogs.objects.create(
        type=action_type,
        tabela=table,
        action=action,
        description=description
    )

def HomeView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormAddress(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Address', 'POST', 'Um endereço foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Address, pk=pk)
        form = ItemFormAddress(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Address', 'PUT', f'Endereço ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Address, pk=pk)
        item.delete()
        log_action('INFO', 'Address', 'DELETE', f'Endereço ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
       clientes_recentes= get_clientes_recentes()
       numero_clientes = contar_clientes()
       now = datetime.now()
       month = now.month
       year = now.year 
       monthly_profit = calculate_monthly_profit(month, year)
       total_profit = calculate_total_profit()
       visitas_tecnicas = get_visitas_tecnicas()
       context = {
           'clientes_recentes':clientes_recentes,
           'numero_clientes': numero_clientes,
           'monthly_profit': monthly_profit,
           'total_profit': total_profit,
           'visitas_tecnicas': visitas_tecnicas
        }
       return render(request, 'home.html', context)

    return JsonResponse({'error': 'Method not allowed'}, status=405)


def AddressView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormAddress(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Address', 'POST', 'Um endereço foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Address, pk=pk)
        form = ItemFormAddress(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Address', 'PUT', f'Endereço ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Address, pk=pk)
        item.delete()
        log_action('INFO', 'Address', 'DELETE', f'Endereço ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Address.objects.all()
        form = ItemFormAddress()
        return render(request, 'address.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

# Mesma abordagem aplicada nas demais views
def DevicesTypeView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormDevicesType(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'DevicesType', 'POST', 'Um tipo de dispositivo foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(DevicesType, pk=pk)
        form = ItemFormDevicesType(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'DevicesType', 'PUT', f'Tipo de dispositivo ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(DevicesType, pk=pk)
        item.delete()
        log_action('INFO', 'DevicesType', 'DELETE', f'Tipo de dispositivo ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = DevicesType.objects.all()
        form = ItemFormDevicesType()
        return render(request, 'devicesType.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def DeviceView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormDevice(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Device', 'POST', 'Um dispositivo foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Device, pk=pk)
        form = ItemFormDevice(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Device', 'PUT', f'Dispositivo ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Device, pk=pk)
        item.delete()
        log_action('INFO', 'Device', 'DELETE', f'Dispositivo ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Device.objects.all()
        form = ItemFormDevice()
        return render(request, 'device.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def DiscountView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormDiscount(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Discount', 'POST', 'Um desconto foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Discount, pk=pk)
        form = ItemFormDiscount(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Discount', 'PUT', f'Desconto ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Discount, pk=pk)
        item.delete()
        log_action('INFO', 'Discount', 'DELETE', f'Desconto ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Discount.objects.all()
        form = ItemFormDiscount()
        return render(request, 'discount.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlan(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Plan', 'POST', 'Um plano foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Plan, pk=pk)
        form = ItemFormPlan(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Plan', 'PUT', f'Plano ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Plan, pk=pk)
        item.delete()
        log_action('INFO', 'Plan', 'DELETE', f'Plano ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Plan.objects.all()
        form = ItemFormPlan()
        return render(request, 'plan.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def SubcriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormSubscription(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Subscription', 'POST', 'Uma assinatura foi adicionada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Subscription, pk=pk)
        form = ItemFormSubscription(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Subscription', 'PUT', f'Assinatura ID {pk} foi atualizada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Subscription, pk=pk)
        item.delete()
        log_action('INFO', 'Subscription', 'DELETE', f'Assinatura ID {pk} foi excluída.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Subscription.objects.all()
        form = ItemFormSubscription()
        return render(request, 'subscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PaymentView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPayment(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Payment', 'POST', 'Um pagamento foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(Payment, pk=pk)
        form = ItemFormPayment(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'Payment', 'PUT', f'Pagamento ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Payment, pk=pk)
        item.delete()
        log_action('INFO', 'Payment', 'DELETE', f'Pagamento ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = Payment.objects.all()
        form = ItemFormPayment()
        return render(request, 'payment.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def TecnicalVisitView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormTecnicalVisit(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'TecnicalVisit', 'POST', 'Uma visita técnica foi adicionada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(TecnicalVisit, pk=pk)
        form = ItemFormTecnicalVisit(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'TecnicalVisit', 'PUT', f'Visita técnica ID {pk} foi atualizada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(TecnicalVisit, pk=pk)
        item.delete()
        log_action('INFO', 'TecnicalVisit', 'DELETE', f'Visita técnica ID {pk} foi excluída.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = TecnicalVisit.objects.all()
        form = ItemFormTecnicalVisit()
        return render(request, 'tecnicalVisit.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def SubcriptionVisitView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormSubcriptionVisit(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'SubcriptionVisit', 'POST', 'Uma visita de assinatura foi adicionada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(SubcriptionVisit, pk=pk)
        form = ItemFormSubcriptionVisit(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'SubcriptionVisit', 'PUT', f'Visita de assinatura ID {pk} foi atualizada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(SubcriptionVisit, pk=pk)
        item.delete()
        log_action('INFO', 'SubcriptionVisit', 'DELETE', f'Visita de assinatura ID {pk} foi excluída.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = SubcriptionVisit.objects.all()
        form = ItemFormSubcriptionVisit()
        return render(request, 'subcriptionVisit.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanDeviceView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlanDevice(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'PlanDevice', 'POST', 'Um dispositivo de plano foi adicionado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(PlanDevice, pk=pk)
        form = ItemFormPlanDevice(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'PlanDevice', 'PUT', f'Dispositivo de plano ID {pk} foi atualizado.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(PlanDevice, pk=pk)
        item.delete()
        log_action('INFO', 'PlanDevice', 'DELETE', f'Dispositivo de plano ID {pk} foi excluído.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = PlanDevice.objects.all()
        form = ItemFormPlanDevice()
        return render(request, 'planDevice.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanSubscriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlanSubscription(data)
        if form.is_valid():
            form.save()
            log_action('INFO', 'PlanSubscription', 'POST', 'Uma assinatura de plano foi adicionada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'PUT':
        if pk is None:
            return HttpResponseBadRequest("ID is required for PUT request.")
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON'}, status=400)

        item = get_object_or_404(PlanSubscription, pk=pk)
        form = ItemFormPlanSubscription(data, instance=item)
        if form.is_valid():
            form.save()
            log_action('INFO', 'PlanSubscription', 'PUT', f'Assinatura de plano ID {pk} foi atualizada.')
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(PlanSubscription, pk=pk)
        item.delete()
        log_action('INFO', 'PlanSubscription', 'DELETE', f'Assinatura de plano ID {pk} foi excluída.')
        return JsonResponse({'success': True})

    elif request.method == 'GET':
        items = PlanSubscription.objects.all()
        form = ItemFormPlanSubscription()
        return render(request, 'planSubscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)
