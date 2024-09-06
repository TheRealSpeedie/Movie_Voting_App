from django.db import models

class Raum(models.Model):
    id = models.CharField("ID", max_length=150, primary_key=True)
    AmountMembers = models.IntegerField("Amount of Members")
    StopCount = models.IntegerField("Amount of Stop")
    Genre_ID = models.IntegerField("Genre_ID")

    def __str__(self) -> str:
        return f"ID: {self.id}  Amount of Members: {self.AmountMembers} Amount of Stop: {self.StopCount}"
    
class Film(models.Model):
    ID = id
    Raum = models.ForeignKey(Raum, on_delete=models.CASCADE, default=1, null=True)
    votes = models.IntegerField("Amount of Votes")
    filmName = models.CharField("Filmname", max_length=100, null=True)
    movieApiID = models.IntegerField("movieApiID")
    description =  models.CharField("Description", max_length=1000, null=True)
    image =  models.CharField("Image", max_length=1000, null=True)
    genres = models.JSONField("Genres", default=list)  
    forAdult = models.BooleanField("For Adult") 
    voteAverage = models.FloatField("Vote Average")  

    def __str__(self) -> str:
        return f"ID: {self.id} Amount of Votes: {self.votes} Filmname: {self.filmName}"

class Themes(models.Model):
    Raum = models.ForeignKey(Raum, on_delete=models.CASCADE, default=1, null=True)
    brightness = models.CharField("brightness", max_length=100, null=True)
    background = models.CharField("background", max_length=100, null=True)
    onBackground = models.CharField("onBackground", max_length=100, null=True)
    primary = models.CharField("primary", max_length=100, null=True)
    onPrimary = models.CharField("onPrimary", max_length=100, null=True)
    secondary = models.CharField("secondary", max_length=100, null=True)
    onSecondary = models.CharField("onSecondary", max_length=100, null=True)
    surface = models.CharField("surface", max_length=100, null=True)
    onSurface = models.CharField("onSurface", max_length=100, null=True)
    error = models.CharField("error", max_length=100, null=True)
    onError = models.CharField("onError", max_length=100, null=True)

