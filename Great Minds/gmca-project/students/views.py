from rest_framework import viewsets, permissions
from .models import Student, SchoolClass, IntakeApplication
from .serializers import StudentSerializer, SchoolClassSerializer, IntakeApplicationSerializer

class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class SchoolClassViewSet(viewsets.ModelViewSet):
    queryset = SchoolClass.objects.all()
    serializer_class = SchoolClassSerializer

class IntakeApplicationViewSet(viewsets.ModelViewSet):
    queryset = IntakeApplication.objects.all().order_by('-submitted_at')
    serializer_class = IntakeApplicationSerializer