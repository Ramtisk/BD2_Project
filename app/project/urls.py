from django.urls import path
from . import views

urlpatterns = [
    path('', views.DevicesTypeList, name='DevicesTypeList'),

    path('devices_type', views.DevicesTypeList, name='DevicesTypeList'),
    path('devices_type/<int:pk>/', views.DevicesTypeFind, name='DevicesTypeFind'),
    path('devices_type/new/', views.DevicesTypeCreate, name='DevicesTypeCreate'),
    path('devices_type/<int:pk>/edit/', views.DevicesTypeUpdate, name='DevicesTypeUpdate'),
    path('devices_type/<int:pk>/delete/', views.DevicesTypeDelete, name='DevicesTypeDelete'),
]