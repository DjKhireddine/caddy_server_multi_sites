from django.contrib import admin
from django.urls import path
from django.views.generic import TemplateView
from .views import HealthCheckView, HelloAPIView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', TemplateView.as_view(template_name='index.html'), name='accueil'),
    path('health/', HealthCheckView.as_view(), name='health'),
    path('api/hello/', HelloAPIView.as_view(), name='api_hello'),
]
