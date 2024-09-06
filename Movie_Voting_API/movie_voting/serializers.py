from rest_framework import serializers

from .models import Film, Raum, Themes

class RaumSerializer(serializers.ModelSerializer):
    class Meta:
        model = Raum
        fields = '__all__'

class FilmSerializer(serializers.ModelSerializer):
    class Meta:
        model = Film
        fields = '__all__'

class ThemeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Themes
        fields = '__all__'

