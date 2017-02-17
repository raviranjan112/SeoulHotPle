"""seoulhot URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.10/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""


from django.conf.urls import url, include
from django.contrib import admin
import advertise
from advertise.views import searchurl, searchpost

urlpatterns = [
    url(r'^admin/', admin.site.urls),

    url(r'^advertise/', include('advertise.urls')),
    url(r'^searchurl/(?P<station>[가-힣]+)/(?P<search>[가-힣]+)', searchurl ,name='searchUrl'),
    url(r'^searchpost/', searchpost, name='searchPost')
]
