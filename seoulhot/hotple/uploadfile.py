import codecs

import os
from seoulhot.settings import BASE_DIR
from .models import SubModel, LineNumber, Population

import datetime


def container():
    f = open(os.path.join(BASE_DIR,'2014.txt'), 'r', encoding='euc-kr')
    station_name = []
    for i in f:
        i = i.split()
        i[2] = ''.join(c for c in i[2] if not c in '()1234567890')
        print(str(i[0])+'------'+i[2]+'-------'+i[3])
        line_number = LineNumber.objects.get(line_number=i[1])
        station = SubModel(
            line_number=line_number,
            station=i[2],
            )
        station.save()
        for j in range(4, 28):
