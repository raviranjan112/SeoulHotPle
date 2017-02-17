from django.shortcuts import render
from .models import AdModel
from .forms import AdModelForm
from hotple.models import Station, SubwayModel
from django.db.models import Q
from django.views.decorators.csrf import csrf_exempt

from datetime import datetime
# Create your views here.

def add_ad_form(request):
    template_name = "ad/new_ad.html"
    formset = AdModelForm()
    if request.method == 'POST':
        formset = AdModelForm(request.POST)

        if formset.is_valid():
            formset.save()

            return redirect('/searchurl')
        else:
            formset = AdModelForm()
        return render(request, template_name,{'form': formset,})
    return render(request, template_name,{'form': formset,})

def searchurl(request, search, station):
    now = datetime.now()
    print(station)
    template_name = 'ad/search.html'
    queryset_list = []
    station_obj = Station.objects.filter(station_name__icontains=station)
    qs = AdModel.objects.filter(word__icontains=search, ad_location=station_obj)
    now = '2014-{month:02}-{day:02}'.format(year=now.year, month=now.month, day=now.day)
    print(now)
    subway = SubwayModel.objects.filter(date=now, station=station_obj[0])

    print(subway)

    print(qs)
    return render(request, template_name, {'qs': qs, 'stations': station_obj})


@csrf_exempt
def searchpost(request):
    re
    template_name = 'ad/searchpost.html'
    if request.method == 'POST':
        station_name = request.POST['station']
        keyword = request.POST['keyword']
        if station_name:
            station = Station.objects.get(station_name=station_name)
            if keyword:
                company = AdModel.objects.filter(word__icontains=keyword, station=station)
        else:
            company = AdModel.objects.filter(word__icontains=keyword)

        return render(request, template_name, {'qs': company})
    return render(request, template_name, {})
