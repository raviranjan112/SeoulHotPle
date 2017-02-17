from django.shortcuts import render
from .models import AdModel
from .forms import AdModelForm
from hotple.models import Station
from django.db.models import Q
# Create your views here.

def add_ad_form(request):
    template_name = "ad/new_ad.html"
    formset = AdModelForm()
    if request.method == 'POST':
        formset = AdModelForm(request.POST)

        if formset.is_valid():
            formset.save()

            return render(request, template_name, {'form': formset})
        else:
            formset = AdModelForm()
        return render(request, template_name,{'form': formset,})
    return render(request, template_name,{'form': formset,})

def searchurl(request, search):
    template_name = 'ad/search.html'
    qs = AdModel.objects.filter(word__icontains=search)
    print(qs)
    return render(request, template_name, {'qs': qs})

def searchpost(request):
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
