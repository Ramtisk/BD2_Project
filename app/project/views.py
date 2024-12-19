from django.shortcuts import render, get_object_or_404, redirect
from django.http import JsonResponse
from .models import DevicesType
from .forms import ItemFormDevicesType

import json
from django.http import JsonResponse, HttpResponseBadRequest
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render, get_object_or_404
from .models import DevicesType
from .forms import ItemFormDevicesType

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
