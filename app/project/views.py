from django.shortcuts import render, get_object_or_404, redirect
from django.http import JsonResponse
from .models import DevicesType
from .forms import ItemFormDevicesType

import json
from django.http import JsonResponse, HttpResponseBadRequest
from django.shortcuts import render, get_object_or_404
from .models import DevicesType,Address,Device,Discount,Payment,Plan,PlanSubscription,SubcriptionVisit,Subscription,TecnicalVisit
from .forms import ItemFormSubscription,ItemFormDevicesType,ItemFormAddress,ItemFormDevice,ItemFormDiscount,ItemFormPayment,ItemFormPlan,ItemFormPlanSubscription,ItemFormSubcriptionVisit,ItemFormTecnicalVisit

def DevicesTypeView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormDevicesType(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(DevicesType, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = DevicesType.objects.all()
        form = ItemFormDevicesType()
        return render(request, 'devicesType.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def AddressView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormAddress(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Address, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Address.objects.all()
        form = ItemFormAddress()
        return render(request, 'address.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def DeviceView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormDevice(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Device, pk=pk)
        item.delete()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Discount, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Discount.objects.all()
        form = ItemFormDiscount()
        return render(request, 'discount.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PaymentView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPayment(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Payment, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Payment.objects.all()
        form = ItemFormPayment()
        return render(request, 'payment.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlan(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Plan, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Plan.objects.all()
        form = ItemFormPlan()
        return render(request, 'plan.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanSubscriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlanSubscription(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(PlanSubscription, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = PlanSubscription.objects.all()
        form = ItemFormPlanSubscription()
        return render(request, 'planSubscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def SubcriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormSubscription(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Subscription, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Subscription.objects.all()
        form = ItemFormSubscription()
        return render(request, 'Subscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def PlanSubscriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormPlanSubscription(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(PlanSubscription, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = PlanSubscription.objects.all()
        form = ItemFormPlanSubscription()
        return render(request, 'planSubscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def SubcriptionVisitView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormSubcriptionVisit(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(SubcriptionVisit, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = SubcriptionVisit.objects.all()
        form = ItemFormSubcriptionVisit()
        return render(request, 'subcriptionVisit.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def SubscriptionView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormSubscription(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(Subscription, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = Subscription.objects.all()
        form = ItemFormSubscription()
        return render(request, 'subscription.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)

def TecnicalVisitView(request, pk=None):
    if request.method == 'POST':
        data = json.loads(request.body)
        form = ItemFormTecnicalVisit(data)
        if form.is_valid():
            form.save()
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
            return JsonResponse({'success': True})
        return JsonResponse({'error': form.errors}, status=400)

    elif request.method == 'DELETE':
        if pk is None:
            return HttpResponseBadRequest("ID is required for DELETE request.")
        item = get_object_or_404(TecnicalVisit, pk=pk)
        item.delete()
        return JsonResponse({'success': True})

    elif request.method == 'GET': 
        items = TecnicalVisit.objects.all()
        form = ItemFormTecnicalVisit()
        return render(request, 'tecnicalVisit.html', {'items': items, 'form': form})

    return JsonResponse({'error': 'Method not allowed'}, status=405)
