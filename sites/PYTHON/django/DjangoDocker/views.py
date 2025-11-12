from django.http import JsonResponse
from django.db import connection
from django.views import View
from django.utils import timezone
import os
import platform
import sys

class HealthCheckView(View):
    def get(self, request):
        """
        Endpoint de santé de l'application
        """
        try:
            # Vérifier la connexion à la base de données
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
            db_status = "ok"
            db_message = "Database connection successful"
        except Exception as e:
            db_status = "error"
            db_message = str(e)

        # Informations système
        system_info = {
            "python_version": platform.python_version(),
            "django_version": self.get_django_version(),
            "platform": platform.platform(),
            "environment": "development" if os.getenv('DEBUG') == 'True' else "production"
        }

        return JsonResponse({
            "status": "ok" if db_status == "ok" else "error",
            "timestamp": timezone.now().isoformat(),
            "service": "Django API",
            "version": "1.0.0",
            "database": {
                "status": db_status,
                "message": db_message,
                "host": os.getenv('DB_HOST', 'unknown'),
                "name": os.getenv('DB_NAME', 'unknown')
            },
            "system": system_info,
            "uptime": self.get_uptime()
        })

    def get_django_version(self):
        """Retourne la version de Django"""
        import django
        return django.get_version()

    def get_uptime(self):
        """Simule un temps de fonctionnement (en production, utiliser un vrai monitoring)"""
        return "running"


class HelloAPIView(View):
    def get(self, request):
        """
        Endpoint de bienvenue de l'API
        """
        return JsonResponse({
            "message": "Hello from Django API! 🚀",
            "timestamp": timezone.now().isoformat(),
            "framework": "Django",
            "language": "Python",
            "features": [
                "REST API",
                "MariaDb Database",
                "Docker Container",
                "Caddy Reverse Proxy"
            ],
            "endpoints": {
                "health": "/health",
                "hello": "/api/hello",
                "admin": "/admin",
            }
        })
