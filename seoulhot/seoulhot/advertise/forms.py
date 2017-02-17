from django import forms
# Create your models here.
from .models import  AdModel
from hotple.models import Station
from django.forms.models import inlineformset_factory


class AdModelForm(forms.ModelForm):
    ad_location = forms.ModelChoiceField(queryset=Station.objects.all())
    class Meta:
        model = AdModel
        fields = '__all__'
        widgets = {
            'company_name' : forms.TextInput(attrs={'class': 'company_name', 'placeholder' : 'Company Name'}),
            'company_location' : forms.TextInput(attrs={'class': 'company_location', 'placeholder' : 'Company Location'}),
            'word' : forms.TextInput(attrs={'class': 'word','placeholder' : 'Key Word'}),
            'credit' : forms.NumberInput(attrs={'class':'credit','placeholder' : 'Credit'}),
            'phone_number' : forms.TextInput(attrs={'class': 'phone_number ','placeholder' : 'Phone number'})
            
        }


    #     class MyForm(forms.ModelForm):
    # class Meta:
    #     model = MyModel
    #     widgets = {
    #         'myfield': forms.TextInput(attrs={'class': 'myfieldclass'}),
    #     }
