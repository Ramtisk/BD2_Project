from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("", include('authentication.urls')),
    path("", include("client.urls")),
    path("backoffice/", include("project.urls")),
    path("admin/", admin.site.urls)
]