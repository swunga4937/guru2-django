from django.db import models

# Create your models here.
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    profile = models.ImageField(upload_to='user_profile/',blank=True)
    message=models.TextField(blank=True)
