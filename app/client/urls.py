from django.urls import path
from . import views

urlpatterns = [
    path('client/', views.ClientView,name='clientHome'),
    path('client/sign/<int:id>/', views.ClientSignView, name='clientSign'),
]
