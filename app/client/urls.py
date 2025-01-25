from django.urls import path
from . import views

urlpatterns = [
    path('client/', views.ClientView, name='Client'),
]
