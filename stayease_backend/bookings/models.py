from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    pass
class Hotel(models.Model):
    name = models.CharField(max_length=100)
    location = models.CharField(max_length=100)
    price = models.IntegerField()
    image = models.URLField()

    def __str__(self):
        return self.name


class Booking(models.Model):
    user_name = models.CharField(max_length=100)
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    nights = models.IntegerField()
    total_price = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)