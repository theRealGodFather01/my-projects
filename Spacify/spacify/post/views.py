from django.contrib.auth.decorators import login_required
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import get_object_or_404, redirect, render
from django.template import loader
from django.urls import reverse
#Models
from comment.models import Comment
from authy.models import Profile
from post.models import Likes, Post, Stream, Tag
#Form
from post.forms import NewPostForm
from comment.forms import commentForm
# Create your views here.

@login_required(login_url = '/login')
def userDashboard(request):
    user = request.user
    posts = Stream.objects.filter(user=user)

    group_ids = []

    for post in posts:
        group_ids.append(post.post_id)
    
    post_items = Post.objects.filter(id__in=group_ids).all().order_by('-posted')

    template = loader.get_template('user_dashboard.html')

    context = {
        'post_items': post_items,
    }

    return HttpResponse(template.render(context, request))

@login_required(login_url = '/login')
def postDetails(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    user = request.user
    saved = False
    liked = False


    if request.user.is_authenticated:
        profile = Profile.objects.get(user=request.user)
        user = request.user
        post = Post.objects.get(id=post_id)

        postLiked = Likes.objects.filter(user=user, post=post)

        if profile.favorites.filter(id=post_id).exists():
            saved = True
        
        if postLiked.exists():
            liked = True

    #Comment
    comments =  Comment.objects.filter(post=post).order_by('date')

    #Comment form
    
    form = commentForm()
    if request.method == 'POST':
        form = commentForm(request.POST)
        if form.is_valid():
            comment = form.save(commit=False)
            comment.post = post
            comment.user = user
            comment.save()
            return HttpResponseRedirect(reverse('postdetails', args=[post_id]))
        else:
            form = commentForm()

    
    template = loader.get_template('post_details.html')

    context = {
        'post': post,
        'saved': saved,
        'liked': liked,
        'form': form,
        'comments': comments,
    }

    context = context

    return HttpResponse(template.render(context, request))


@login_required(login_url = '/login')
def newPost(request):
    user = request.user.id
    tags_objs = []

    if request.method == 'POST':
        form = NewPostForm(request.POST, request.FILES)
        if form.is_valid():
            picture = form.cleaned_data.get('picture')
            caption = form.cleaned_data.get('caption')
            tags_form = form.cleaned_data.get('tags')

            tags_list = list(tags_form.split(','))

            for tag in tags_list:
                t, created = Tag.objects.get_or_create(title=tag)
                tags_objs.append(t)
            
            p, created = Post.objects.get_or_create(picture=picture, caption=caption, user_id=user)
            p.tags.set(tags_objs)
            p.save()

            return redirect('dashboard')
    else:
        form = NewPostForm()
    
    context = {
        'form': form,
    }

    return render(request, 'new_post.html', context)

@login_required(login_url = '/login')
def tags(request, tag_slug):
    tag = get_object_or_404(Tag, slug=tag_slug)
    posts = Post.objects.filter(tags=tag).order_by('-posted')

    template = loader.get_template('tags.html')

    context = {
        'posts': posts,
        'tag': tag,
    }

    return HttpResponse(template.render(context, request))

@login_required(login_url = '/login')
def like(request, post_id):
    user = request.user
    post = Post.objects.get(id=post_id)
    current_likes = post.likes

    liked = Likes.objects.filter(user=user, post=post).count()

    if not liked:
        Likes.objects.create(user=user, post=post)
        current_likes = current_likes + 1

    else:
        Likes.objects.filter(user=user, post=post).delete()
        current_likes = current_likes - 1
    
    post.likes = current_likes
    post.save()

    return HttpResponseRedirect(reverse('postdetails', args=[post_id]))

@login_required(login_url = '/login')
def favorite(request, post_id):
    user = request.user
    post = Post.objects.get(id=post_id)
    profile = Profile.objects.get(user=user)

    if profile.favorites.filter(id=post_id).exists():
        profile.favorites.remove(post)
    else:
        profile.favorites.add(post)
    
    return HttpResponseRedirect(reverse('postdetails', args=[post_id]))