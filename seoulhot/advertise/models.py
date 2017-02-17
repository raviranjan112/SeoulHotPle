from django.db import models
from hotple.models import Station

class AdModel(models.Model):
    company_name = models.CharField(max_length=100)
    ad_location = models.ForeignKey(Station)
    company_location = models.CharField(max_length=100)
    word = models.CharField(max_length=200)
    credit = models.IntegerField(default=0)
    phone_number = models.CharField(max_length=100)

    def __str__(self):
        return self.company_name
