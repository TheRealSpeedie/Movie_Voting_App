# Generated by Django 5.0.1 on 2024-03-08 12:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('movie_voting', '0013_film_description'),
    ]

    operations = [
        migrations.AlterField(
            model_name='film',
            name='description',
            field=models.CharField(max_length=1000, null=True, verbose_name='Description'),
        ),
    ]
