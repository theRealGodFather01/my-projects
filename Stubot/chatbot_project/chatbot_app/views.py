# from django.http import JsonResponse
# from django.views.decorators.csrf import csrf_exempt
# from .models import ChatMessage
# import json

# @csrf_exempt
# def handle_message(request):
#     if request.method == 'POST':
#         data = json.loads(request.body.decode('utf-8'))
#         user_message = data.get('message', '')

#         # Save the user's message to the database
#         ChatMessage.objects.create(user='User', message=user_message)

#         # Get a response from the chatbot
#         bot_response = "Hello! I'm a simple chatbot. You said: {}".format(user_message)

#         # Save the chatbot's response to the database
#         ChatMessage.objects.create(user='Chatbot', message=bot_response)

#         return JsonResponse({'response': bot_response})
#     else:
#         return JsonResponse({'error': 'Invalid request method'})
# from django.shortcuts import render
# from django.http import JsonResponse
# import requests
# from chatbot_project import settings

# def chatbot(request):
#     return render(request, 'chatbot_app/chatbot.html')

# def get_bot_response(user_message):
#     # Send user message to Rasa server
#     rasa_url = f"{settings.RASA_SERVER}/webhooks/rest/webhook"
#     response = requests.post(rasa_url, json={"message": user_message})

#     # Extract and return the bot's response
#     if response.status_code == 200:
#         return response.json()
#     else:
#         return {"error": "Failed to get a response from the bot."}

# def chatbot_api(request):
#     if request.method == 'POST':
#         data = request.POST.get('message', '')
#         bot_response = get_bot_response(data)
#         return JsonResponse(bot_response, safe=False)
#     else:
#         return JsonResponse({"error": "Invalid request method"})

from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .models import User, Student

@csrf_exempt  # Disable CSRF
def handleUserInfo(request):
    if request.method == 'POST':
        # Assuming the request data is in JSON format
        data = json.loads(request.body.decode('utf-8'))

        # Get the user input from the AJAX request
        email = data.get('userEmail', '')
        phone_number = data.get('userPhoneNumber', '')

        # Check if the user exists in the database
        user_exists = User.objects.filter(email=email, phone_number=phone_number).exists()

        # Perform actions based on user existence
        if user_exists:
            # Check if the user is a student
            is_student = Student.objects.filter(email=email, phone_number=phone_number).exists()

            if is_student:
                # Update user model for students
                user = User.objects.get(email=email, phone_number=phone_number)
                user.is_student = True
                user.is_active = True
                user.save()

                response_message = f'Welcome back student, {email}!'
            else:
                # Update user model for non-students
                user = User.objects.get(email=email, phone_number=phone_number)
                user.is_active = True
                user.save()

                response_message = f'Welcome back user, {email}!'

        else:
            # Create a new user if not exists
            new_user = User.objects.create(email=email, phone_number=phone_number, is_active=True)
            new_user.is_active = True
            new_user.save()

            response_message = f'Welcome to Uniuyo first time user, {email}!'

        # Send a response back to the client
        response_data = {
            'message': response_message,
        }

        return JsonResponse(response_data)

    return JsonResponse({'error': 'Invalid request method'})

@csrf_exempt  # Disable CSRF
def handleUserMessage(request):
    if request.method == 'POST':
        # Assuming the request data is in JSON format
        data = json.loads(request.body.decode('utf-8'))

        # Get the user input from the AJAX request
        user_message = data.get('user_message', '')

        # Perform any processing or business logic here

        # Send a response back to the client
        response_data = {
            'message': f'Thanks for your input: {user_message}',
        }

        return JsonResponse(response_data)

    return JsonResponse({'error': 'Invalid request method'})

def homeView(request):
    return render(request, 'index.html')
