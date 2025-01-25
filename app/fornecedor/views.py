from django.contrib.auth.decorators import login_required, user_passes_test
from django.shortcuts import render, redirect
from project.models import Device, DevicesType
from .forms import DeviceForm, DevicesTypeForm
from django.contrib import messages


def is_fornecedor(user):
    return user.groups.filter(name='fornecedor').exists()

def fornecedor_home(request):
    if request.session.get('user_group') != 'fornecedor':
        messages.error(request, "Acesso negado.")
        return redirect('login')
    return render(request, 'fornecedor_home.html')


def manage_devices(request):
    if request.session.get('user_group') != 'fornecedor':
        messages.error(request, "Acesso negado.")
        return redirect('login')
    
    if request.method == 'POST':
        form = DeviceForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('manage_devices')
    else:
        form = DeviceForm()
    devices = Device.objects.all()
    return render(request, 'manage_devices.html', {'form': form, 'devices': devices})

def manage_devices_type(request):
    if request.session.get('user_group') != 'fornecedor':
        messages.error(request, "Acesso negado.")
        return redirect('login')
    if request.method == 'POST':
        form = DevicesTypeForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('manage_devices_type')
    else:
        form = DevicesTypeForm()
    devices_types = DevicesType.objects.all()
    return render(request, 'manage_devices_type.html', {'form': form, 'devices_types': devices_types})
