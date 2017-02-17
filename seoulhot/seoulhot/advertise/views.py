from django.shortcuts import render
from .models import AdModel
from .forms import AdModelForm
from hotple.models import Station, SubwayModel
from django.db.models import Q
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json
from datetime import datetime
# from django.utils import simplejson
from django.core import serializers
from django.http import HttpResponse
import random

def add_ad_form(request):
    template_name = "ad/new_ad.html"
    formset = AdModelForm()
    if request.method == 'POST':
        formset = AdModelForm(request.POST)
        print(request.POST)
        if formset.is_valid():
            formset.save()

        return render(request, template_name, {'form': formset})
    formset = AdModelForm()
    return render(request, template_name,{'form': formset,})
    

def searchurl(request, search, station):
    now = datetime.now()
    print(station)
    template_name = 'ad/search.html'
    station_obj = Station.objects.filter(station_name__icontains=station)
    qs = AdModel.objects.filter(word__icontains=search, ad_location=station_obj)
    now_ymd = '2014-{month:02}-{day:02}'.format(year=now.year, month=now.month, day=now.day)
    subway = SubwayModel.objects.filter(date=now_ymd, station=station_obj[0])
    print(subway)
    print(qs)
    
    population = 0
    time_stamp = 'sub.population' + str(now.hour)
    for sub in subway:
        population += eval(time_stamp)
    print(population)
    
    return render(request, template_name, {'qs': qs, 'stations': station_obj, 'population' : population})

@csrf_exempt
def searchpost(request):
    template_name = 'ad/search.html'
    now = datetime.now()
    now_ymd = '2014-{month:02}-{day:02}'.format(year=now.year, month=now.month, day=now.day)
    if request.method == 'POST':
        station_name = request.POST.get('station', False)
        roomkey = request.POST.get('roomkey', False)
        print(request.POST)
        keyword = request.POST.get('keyword',False)
        if station_name:
            station = Station.objects.filter(station_name__icontains=station_name)
            subway = SubwayModel.objects.filter(date=now_ymd, station=station[0])
            population = 0
            time_stamp = 'sub.population' + str(now.hour)
            for sub in subway:
                population += eval(time_stamp)
            print(population)
            if keyword:
                company = AdModel.objects.filter(word__icontains=keyword, ad_location=station)
        else:
            company = AdModel.objects.filter(word__icontains=keyword)
        
        if company:
            num = random.randrange(company.count())
            restaurant = company[num].company_name
            location = company[num].company_location
            phone = company[num].phone_number
        
        context = {
            'one_station' : station[0].station_name,
            'population': population,
            'roomkey' : roomkey,
            'restaurant' : restaurant,
            'location' : location,
            'phone' : phone,
        }
        data =json.dumps(context)
        return HttpResponse(data, content_type='application/json')
    return render(request, template_name, {})
