from django import forms
# Create your models here.
from .models import  AdModel
from hotple.models import Station
from django.forms.models import inlineformset_factory


class AdModelForm(forms.ModelForm):

    class Meta:
        model = AdModel
        fields = '__all__'
        widgets = {
            'company_name' : forms.TextInput(attrs={'class': 'company_name'}),
            'company_location' : forms.TextInput(attrs={'class': 'company_location'}),
            'word' : forms.TextInput(attrs={'class': 'word'}),
            'credit' : forms.NumberInput(attrs={'class':'credit'}),
            'phone_number' : forms.TextInput(attrs={'class': 'phone_number'})
        }


    #     class MyForm(forms.ModelForm):
    # class Meta:
    #     model = MyModel
    #     widgets = {
    #         'myfield': forms.TextInput(attrs={'class': 'myfieldclass'}),
    #     }
