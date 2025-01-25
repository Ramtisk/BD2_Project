from django.urls import path
from . import views

urlpatterns = [
    path('', views.fornecedor_home, name='fornecedor_home'),
    path('devices/', views.manage_devices, name='manage_devices'),
    path('devices-type/', views.manage_devices_type, name='manage_devices_type'),
]
