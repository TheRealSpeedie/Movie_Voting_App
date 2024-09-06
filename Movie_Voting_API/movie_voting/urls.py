from django.urls import path, include
from django.views.generic import TemplateView
from rest_framework.routers import DefaultRouter

from . import views
router = DefaultRouter()
router.register(r'film', views.FilmViewSet, basename='film')
router.register(r'raum', views.RaumViewSet, basename='raum')
router.register(r'theme', views.ThemeViewSet, basename='theme')

urlpatterns = [
     *router.urls,
    path('film/raum/<str:value>', views.FilmViewSet.as_view({'get': 'list_by_raum'}), name='Filme von Raum'),
    path('theme/raum/<str:value>', views.ThemeViewSet.as_view({'get': 'list_by_raum'}), name='Theme von Raum'),
    path(
        "swagger-ui/",
        TemplateView.as_view(
            template_name="swagger-ui.html",
            extra_context={"schema_url": "openapi-schema"},
        ),
        name="swagger-ui",
    ),
]