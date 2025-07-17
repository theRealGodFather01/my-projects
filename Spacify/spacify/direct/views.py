from django.shortcuts import render, redirect, get_object_or_404
from django.template import loader
from django.http import HttpResponse, HttpResponseBadRequest
from django.contrib.auth.decorators import login_required
from authy.views import Follow
from direct.models import Message
from django.contrib.auth.models import User
from django.db.models import Q
from django.core.paginator import Paginator

# Create your views here.

@login_required(login_url = '/login')
def inbox(request):
    user = request.user
    messages = Message.get_messages(user=user)
    active_direct = None
    directs =  None

    if messages:
        message = messages[0]
        active_direct = message['user'].username
        directs = Message.objects.filter(user=user, receipient=message['user'])
        directs.update(is_read=True)

        for message in messages:
            if message['user'].username == active_direct:
                message['unread'] = 0
        context = {
            'directs': directs,
            'messages': messages,
            'active_direct': active_direct,
        }
    template = loader.get_template('direct.html')

    return HttpResponse(template.render(context, request))

@login_required(login_url = '/login')
def Directs(request, username):
    user = request.user
    messages = Message.get_messages(user=user)
    active_direct = username
    directs = Message.objects.filter(user=user, receipient__username=username)
    directs.update(is_read=True)

    for message in messages:
        if message['user'].username == username:
            message['unread'] = 0
    
    context = {
        'directs': directs,
        'messages': messages,
        'active_direct': active_direct,
    }
    template = loader.get_template('direct.html')

    return HttpResponse(template.render(context, request))

@login_required(login_url = '/login')
def SendDirect(request):
    from_user = request.user
    to_user_username = request.POST.get('to_user')
    body = request.POST.get('body')

    if request.method == 'POST':
        to_user = User.objects.get(username=to_user_username)
        Message.send_message(from_user, to_user, body)
        return redirect('inbox')
    else:
        HttpResponseBadRequest()
@login_required(login_url = '/login')
def UserSearch(request):
    query = request.GET.get('q')
    context = {}

    if query:
        users = User.objects.filter(Q(username__icontains=query))

        #Pagination
        paginator = Paginator(users, 6)
        page_number = request.GET.get('page')
        users_paginator = paginator.get_page(page_number)

        context = {
            'users' : users_paginator,
        }
    
    template = loader.get_template('search_user.html')

    return HttpResponse(template.render(context, request))

