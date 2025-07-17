# from django.urls import path
# from .views import chatbot, chatbot_api

# urlpatterns = [
#     path('chatbot/', chatbot, name='chatbot'),
#     path('api/chatbot/', chatbot_api, name='chatbot_api'),
# ]

from django.urls import path
from . import views

urlpatterns = [
    path('', views.homeView, name='home'),
    path('message', views.handleUserMessage, name='message'),
    path('userInfo', views.handleUserInfo, name='userInfo'),
]