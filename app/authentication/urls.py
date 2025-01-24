from django.urls import path
from .views import login_view, logout_view, admin_homepage, fornecedor_homepage, client_homepage

urlpatterns = [
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),
    path('admin_homepage/', admin_homepage, name='admin_homepage'),
    path('fornecedor_homepage/', fornecedor_homepage, name='fornecedor_homepage'),
    path('client_homepage/', client_homepage, name='client_homepage'),
]