import codecs

import os
from seoulhot.settings import BASE_DIR
from .models import SubwayModel

import datetime


def container():
    f = open(os.path.join(BASE_DIR, '2014.txt'), 'r', encoding='euc-kr')

    for i in f:

        i = i.split()
        station = ''.join(c for c in i[2] if c not in '()1234567890')
        print(i[2])
        a = SubwayModel(date=i[0], line_number=i[1], station=station, in_out=i[3],
                        population0=i[4],population1=i[5],population2=i[6],population3=i[7],population4=i[8],
                        population5=i[9],population6=i[10],population7=i[11],population8=i[12],population9=i[13],
                        population10=i[14],population11=i[15],population12=i[16],population13=i[17],population14=i[18],population15=i[19],
                        population16=i[20],population17=i[21],population18=i[22],population19=i[23],population20=i[24],population21=i[25],
                        population22=i[26],population23=i[27])
        a.save()
