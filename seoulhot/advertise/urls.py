from django.conf.urls import url

from .views import add_ad_form
app_name='advertise'

urlpatterns = [
    url(r'^add/', add_ad_form, name='add'),

]
