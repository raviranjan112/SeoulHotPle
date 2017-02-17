import codecs

import os
import xlrd
from datetime import datetime
from seoulhot.settings import BASE_DIR
from .models import SubwayModel, Station

import datetime

def openxl():
    f = xlrd.open_workbook(os.path.join(BASE_DIR, '2014.xlsx'))
    workbook = f.sheet_by_index(0)
    num_rows = workbook.nrows

    for i in range(1,num_rows):
        row = workbook.row_values(i)
        station_name = row[2]

        if '(' in station_name:
            station_name = station_name.split('(')
            station_name = station_name[0]
        if not (station_name[-1] == '역'):
            station_name += '역'
        print(station_name + row[1])
        station = Station.objects.get(station_name=station_name, line_number=row[1])
        obj = SubwayModel(date=row[0], in_out=row[3], station=station,
                        population0=int(row[4]),population1=int(row[5]),population2=int(row[6]),population3=int(row[7]),population4=int(row[8]),
                        population5=int(row[9]),population6=int(row[10]),population7=int(row[11]),population8=int(row[12]),population9=int(row[13]),
                        population10=int(row[14]),population11=int(row[15]),population12=int(row[16]),population13=int(row[17]),population14=int(row[18]),population15=int(row[19]),
                        population16=int(row[20]),population17=int(row[21]),population18=int(row[22]),population19=int(row[23]),population20=int(row[24]),population21=int(row[25]),
                        population22=int(row[26]),population23=int(row[27]))
        obj.save()


def container():
    f = open(os.path.join(BASE_DIR, '2014.txt'), 'r', encoding='euc-kr')

    for i in f:

        i = i.split()
        station_name = i[2]
        for j in range(5):
            station_name = station_name[:-1]

        if '(' in station_name:
            station_name = station_name.split('(')
            station_name = station_name[0]

        print(station_name)
        if not (station_name[-1] == '역'):
            station_name += '역'
        print(station_name+i[1])
        station = Station.objects.get(station_name=station_name, line_number=i[1])
        obj = SubwayModel(date=i[0], in_out=i[3], station=station,
                        population0=i[4],population1=i[5],population2=i[6],population3=i[7],population4=i[8],
                        population5=i[9],population6=i[10],population7=i[11],population8=i[12],population9=i[13],
                        population10=i[14],population11=i[15],population12=i[16],population13=i[17],population14=i[18],population15=i[19],
                        population16=i[20],population17=i[21],population18=i[22],population19=i[23],population20=i[24],population21=i[25],
                        population22=i[26],population23=i[27])
        obj.save()


def addstation():
    f = open(os.path.join(BASE_DIR, 'station.txt'), 'r', encoding='euc-kr')

    for i in f:
        i = i.split()
        station = Station.objects.all()
        obj = Station(station_name=i[0]+'역', line_number=i[1]+'호선')
        if not obj in station:
            obj.save()
        else:
            pass
