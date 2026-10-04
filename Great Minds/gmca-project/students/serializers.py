from rest_framework import serializers
from .models import Student, SchoolClass, IntakeApplication

class SchoolClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = SchoolClass
        fields = '__all__'

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'

class IntakeApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = IntakeApplication
        fields = "__all__"
        read_only_fields = ['submitted_at', 'status']