# Generated by Django 5.0.1 on 2024-02-21 13:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('movie_voting', '0010_remove_raum_number_film_movieapiid'),
    ]

    operations = [
        migrations.AddField(
            model_name='raum',
            name='Genre',
            field=models.CharField(max_length=100, null=True, verbose_name='Genre'),
        ),
    ]
