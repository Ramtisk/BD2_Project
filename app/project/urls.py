from django.urls import path
from . import views

urlpatterns = [
    path('devices_type/', views.DevicesTypeView, name='DevicesType'),
    path('devices_type/<int:pk>/', views.DevicesTypeView, name='DevicesTypeDetail'),
]
