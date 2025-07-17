from django.contrib import admin
from .models import Level, Faculty, Department, Lecturer, Agent, Course, Student, User, Conversation, Message, Escalation, AssignedAgents, Class, Event, News, CutoffMarks

# Register your models here.
# your_app/admin.py

admin.site.register(Level)
admin.site.register(Faculty)
admin.site.register(Department)
admin.site.register(Lecturer)
admin.site.register(Agent)
admin.site.register(Course)
admin.site.register(Student)
admin.site.register(User)
admin.site.register(Conversation)
admin.site.register(Message)
admin.site.register(Escalation)
admin.site.register(AssignedAgents)
admin.site.register(Class)
admin.site.register(Event)
admin.site.register(News)
admin.site.register(CutoffMarks)
