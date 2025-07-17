from django.urls import path
from authy import views

from django.contrib.auth import views as authViews 



urlpatterns = [
   	
    path('', views.index),
	path('profile/edit', views.EditProfile, name='edit-profile'),
   	path('signup/', views.Signup, name='signup'),
   	path('login/', authViews.LoginView.as_view(template_name='login.html'), name='login'),
   	path('logout/', authViews.LogoutView.as_view(), {'next_page' : 'dashboard'}, name='logout'),
	# path('search/', views.UserSearchDashboard, name='usersearchdashboard'),
   	# path('changepassword/', PasswordChange, name='change_password'),
   	# path('changepassword/done', PasswordChangeDone, name='change_password_done'),
   	# path('passwordreset/', authViews.PasswordResetView.as_view(), name='password_reset'),
   	# path('passwordreset/done', authViews.PasswordResetDoneView.as_view(), name='password_reset_done'),
   	# path('passwordreset/<uidb64>/<token>/', authViews.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),
   	# path('passwordreset/complete/', authViews.PasswordResetCompleteView.as_view(), name='password_reset_complete'),


]