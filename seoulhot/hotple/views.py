from django.shortcuts import render

# Create your views here.


def func1(request):

    return render(request,'index.html' , context)
