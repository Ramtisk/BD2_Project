from django.urls import path
from . import views

urlpatterns = [
    path('', views.HomeView, name='adminHome'),

    path('devices_type/', views.DevicesTypeView, name='DevicesType'),
    path('devices_type/<int:pk>/', views.DevicesTypeView, name='DevicesTypeDetail'),

    path('address/', views.AddressView, name='Address'),
    path('address/<int:pk>/', views.AddressView, name='AddressDetail'),
    
    path('device/', views.DeviceView, name='Device'),
    path('device/<int:pk>/', views.DeviceView, name='DeviceDetail'),

    path('discount/', views.DiscountView, name='Discount'),
    path('discount/<int:pk>/', views.DiscountView, name='DiscountDetail'),

    path('payment/', views.PaymentView, name='Payment'),
    path('payment/<int:pk>/', views.PaymentView, name='PaymentDetail'),

    path('plan/', views.PlanView, name='Plan'),
    path('plan/<int:pk>/', views.PlanView, name='PlanDetail'),

    path('plan_subscription/', views.PlanSubscriptionView, name='PlanSubscription'),
    path('plan_subscription/<int:pk>/', views.PlanSubscriptionView, name='PlanSubscriptionDetail'),

    path('subcription_visit/', views.SubcriptionVisitView, name='SubcriptionVisit'),
    path('subcription_visit/<int:pk>/', views.SubcriptionVisitView, name='SubcriptionVisitDetail'),

    path('subcription/', views.SubcriptionView, name='Subcription'),
    path('subcription/<int:pk>/', views.SubcriptionView, name='SubcriptionDetail'),

    path('tecnical_visit/', views.TecnicalVisitView, name='TecnicalVisit'),
    path('tecnical_visit/<int:pk>/', views.TecnicalVisitView, name='TecnicalVisitDetail'),

    path('plan_device/', views.PlanDeviceView, name='PlanDevice'),
    path('plan_device/<int:pk>/', views.PlanDeviceView, name='PlanDeviceDetail'),
]
