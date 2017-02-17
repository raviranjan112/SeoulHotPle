from django.db import models

# Create your models here.
ON_OFF = (
    ('승차', '승차'),
    ('하차', '하차'),
)

class LineNumber(models.Model):
    line_number = models.CharField(max_length=50)

    def __str__(self):
        return self.line_number


class SubModel(models.Model):
    station = models.CharField(max_length=100)
    line_number = models.ForeignKey('LineNumber')
    date = models.DateField(blank=True, null=True)
    time = models.IntegerField(blank=True, null=True)
    number = models.IntegerField(blank=True, null=True)
    on_off = models.CharField(choices=ON_OFF,blank=True, max_length=100)

    def __str__(self):
        return str(self.date) + '-----' +  self.station.station + '-----' + self.on_off
