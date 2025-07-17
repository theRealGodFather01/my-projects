from django.urls import path
from direct import views

urlpatterns = [
   	path('', views.inbox, name='inbox'), 
   	path('<username>', views.Directs, name='directs'),
   	path('send/', views.SendDirect, name='send_direct'),
	path('new/', views.UserSearch, name='usersearch'),
	]