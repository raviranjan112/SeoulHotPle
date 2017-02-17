from django.contrib import admin

from .models import SubwayModel, Station


admin.site.register(SubwayModel)
admin.site.register(Station)
