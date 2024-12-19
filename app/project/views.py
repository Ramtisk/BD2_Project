from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse

# /app/project/templates/views.py
from django.shortcuts import render, get_object_or_404, redirect
from .models import DevicesType
from .forms import ItemForm

def DevicesTypeList(request):
    items = DevicesType.objects.all()
    return render(request, '/app/project/templates/item_list.html', {'items': items})

def DevicesTypeFind(request, pk):
    item = get_object_or_404(DevicesType, pk=pk)
    return render(request, '/app/project/templates/item_detail.html', {'item': item})

def DevicesTypeCreate(request):
    if request.method == 'POST':
        form = ItemForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('DevicesTypeList')
    else:
        form = ItemForm()
    return render(request, '/app/project/templates/item_form.html', {'form': form})

def DevicesTypeUpdate(request, pk):
    item = get_object_or_404(DevicesType, pk=pk)
    if request.method == 'PUT':
        form = ItemForm(request.PUT, instance=item)
        if form.is_valid():
            form.save()
            return redirect('DevicesTypeList')
    else:
        form = ItemForm(instance=item)
    return render(request, '/app/project/templates/item_form.html', {'form': form})

def DevicesTypeDelete(request, pk):
    item = get_object_or_404(DevicesType, pk=pk)
    print('Delete Device ')
    if request.method == 'POST':
        item.delete()
        return redirect('DevicesTypeList')
    return render(request, '/app/project/templates/item_confirm_delete.html', {'item': item})