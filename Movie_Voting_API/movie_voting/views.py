from django.http import Http404
from django.shortcuts import get_object_or_404, render
from rest_framework.views import APIView
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework import status
from rest_framework.schemas.openapi import AutoSchema

from .models import Raum, Film, Themes
from .serializers import RaumSerializer, FilmSerializer, ThemeSerializer

class FilmViewSet(ViewSet):
    queryset = Film.objects.all()
    serializer_class = FilmSerializer

    def list(self, request, *args, **kwargs):
        filmSnippets = Film.objects.all()
        film_serializer = FilmSerializer(filmSnippets, many=True)
        return Response(film_serializer.data)

    def retrieve(self, request, pk=None):
        try:
            film = Film.objects.get(filmName=pk)
            serializer = self.serializer_class(film)
            return Response(serializer.data)
        except Film.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def create(self, request, *args, **kwargs):
        film_serializer = FilmSerializer(data=request.data)
        film_serializer.is_valid(raise_exception=True)
        film_serializer.save()
        return Response(film_serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, pk=None):
        try:
            film = Film.objects.get(filmName=pk)
            serializer = self.serializer_class(film, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Film.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def destroy(self, request, pk=None):
        try:
            film = Film.objects.get(filmName=pk)
            film.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Film.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def list_by_raum(self, request, value=None):
        filter_kwargs = {"Raum": value, "votes__gt": 0}
        films = Film.objects.filter(**filter_kwargs).order_by('-votes')
        if not films:
            return Response(status=status.HTTP_204_NO_CONTENT)

        serializer = self.serializer_class(films, many=True)
        return Response(serializer.data)
    
    def partial_update(self, request, pk=None):
        try:
            film = Film.objects.get(id=pk)
            serializer = self.serializer_class(film, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Film.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

   
class RaumViewSet(ViewSet):
    queryset = Raum.objects.all()
    serializer_class = RaumSerializer

    def list(self, request, *args, **kwargs):
        raumSnippets = Raum.objects.all()
        raum_serializer = RaumSerializer(raumSnippets, many=True)
        return Response(raum_serializer.data)

    def create(self, request, *args, **kwargs):
        raum_serializer = RaumSerializer(data=request.data)
        raum_serializer.is_valid(raise_exception=True)
        raum_serializer.save()
        return Response(raum_serializer.data, status=status.HTTP_201_CREATED)

    def retrieve(self, request, pk=None):
        try:
            filter_kwargs = {"id": pk}
            raum = Raum.objects.filter(**filter_kwargs).first()
            serializer = self.serializer_class(raum)
            return Response(serializer.data)
        except Raum.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def update(self, request, pk=None):
        try:
            filter_kwargs = {"id": pk}
            raum = Raum.objects.filter(**filter_kwargs).first()
            serializer = self.serializer_class(raum, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Raum.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def destroy(self, request, pk=None):
        try:
            filter_kwargs = {"id": pk}
            raum = Raum.objects.filter(**filter_kwargs).first()
            raum.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Raum.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def partial_update(self, request, pk=None):
        try:
            filter_kwargs = {"id": pk}
            raum = Raum.objects.filter(**filter_kwargs).first()
            serializer = self.serializer_class(raum, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Raum.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)


class ThemeViewSet(ViewSet):
    queryset = Themes.objects.all()
    serializer_class = ThemeSerializer

    def list(self, request, *args, **kwargs):
        themesnippets = Themes.objects.all()
        theme_serializer = ThemeSerializer(themesnippets, many=True)
        return Response(theme_serializer.data)

    def create(self, request, *args, **kwargs):
        theme_serializer = ThemeSerializer(data=request.data)
        theme_serializer.is_valid(raise_exception=True)
        theme_serializer.save()
        return Response(theme_serializer.data, status=status.HTTP_201_CREATED)

    def list_by_raum(self, request, value=None):
        filter_kwargs = {"Raum": value, "votes__gt": 0} 
        themes = Themes.objects.filter(**filter_kwargs).order_by('-votes')
        if not themes:
            return Response(status=status.HTTP_204_NO_CONTENT)

        theme_serializer = ThemeSerializer(themes, many=True)
        return Response(theme_serializer.data)


