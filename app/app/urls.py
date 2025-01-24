from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('authentication/', include('authentication.urls')),
    path("v1/", include("project.urls")),
    path("admin/", admin.site.urls)
]