from django.db import models

# Create your models here.
ON_OFF = (
    ('승차', '승차'),
    ('하차', '하차'),
)


class Station(models.Model):
    station_name = models.CharField(blank=True, max_length=100)
    line_number = models.CharField(blank=True, max_length=100)

class SubwayModel(models.Model):
    ''' Seoul Hot place Subway model'''

    date = models.DateField(
                default='2017-01-01',
                verbose_name='date'
                )

    station = models.ForeignKey(
                Station,
                on_delete=models.CASCADE,
                )


    population0 = models.IntegerField(
                default=0,
                verbose_name='0',
                )

    population1 = models.IntegerField(
                default=0,
                verbose_name='1',
                )

    population2 = models.IntegerField(
                default=0,
                verbose_name='2',
                )

    population3 = models.IntegerField(
                default=0,
                verbose_name='3',
                )

    population4 = models.IntegerField(
                default=0,
                verbose_name='4',
                )

    population5 = models.IntegerField(
                default=0,
                verbose_name='5',
                )

    population6 = models.IntegerField(
                default=0,
                verbose_name='6',
                )

    population7 = models.IntegerField(
                default=0,
                verbose_name='7',
                )

    population8 = models.IntegerField(
                default=0,
                verbose_name='8',
                )

    population9 = models.IntegerField(
                default=0,
                verbose_name='9',
                )

    population10 = models.IntegerField(
                default=0,
                verbose_name='10',
                )

    population11 = models.IntegerField(
                default=0,
                verbose_name='11',
                )

    population12 = models.IntegerField(
                default=0,
                verbose_name='12',
                )

    population13 = models.IntegerField(
                default=0,
                verbose_name='13',
                )

    population14 = models.IntegerField(
                default=0,
                verbose_name='14',
                )

    population15 = models.IntegerField(
                default=0,
                verbose_name='15',
                )

    population16 = models.IntegerField(
                default=0,
                verbose_name='16',
                )

    population17 = models.IntegerField(
                default=0,
                verbose_name='17',
                )

    population18 = models.IntegerField(
                default=0,
                verbose_name='18',
                )

    population19 = models.IntegerField(
                default=0,
                verbose_name='19',
                )

    population20 = models.IntegerField(
                default=0,
                verbose_name='20',
                )

    population21 = models.IntegerField(
                default=0,
                verbose_name='21',
                )

    population22 = models.IntegerField(
                default=0,
                verbose_name='22',
                )

    population23 = models.IntegerField(
                default=0,
                verbose_name='23',
                )

    in_out = models.CharField(
                max_length=10,
                choices=ON_OFF,
                default='on',
                verbose_name='on and off',
                )

    def __str__(self):
        return self.station
