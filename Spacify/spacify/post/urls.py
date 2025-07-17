from django.urls import path
from post import views
# from authy.views import UserProfile, Signup, PasswordChange, PasswordChangeDone, EditProfile

from django.contrib.auth import views as authViews 

urlpatterns = [
   	path('newpost', views.newPost, name='newpost'),
    path('<uuid:post_id>', views.postDetails, name='postdetails'),
    path('<uuid:post_id>/like', views.like, name='postlike'),
    path('<uuid:post_id>/save', views.favorite, name='postsave'),
    path('tag/<slug:tag_slug>', views.tags, name='tags'),
    path('dashboard/', views.userDashboard, name='dashboard'),
]