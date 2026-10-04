from django.db import models

class SchoolClass(models.Model):
    name = models.CharField(max_length=64)
    short_name = models.CharField(max_length=16, blank=True)
    description = models.TextField(blank=True)
    def __str__(self): return self.name

class Student(models.Model):
    admission_no = models.CharField(max_length=30, unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    dob = models.DateField(null=True, blank=True)
    classroom = models.ForeignKey(SchoolClass, null=True, blank=True, on_delete=models.SET_NULL)
    parent_name = models.CharField(max_length=200, blank=True)
    parent_phone = models.CharField(max_length=50, blank=True)
    address = models.TextField(blank=True)
    photo = models.ImageField(upload_to='students/photos/', null=True, blank=True)
    joined_date = models.DateField(auto_now_add=True)
    def __str__(self): return f"{self.admission_no} {self.first_name}"

class IntakeApplication(models.Model):
    full_name = models.CharField(max_length=200)
    dob = models.DateField(null=True, blank=True)
    desired_class = models.ForeignKey(SchoolClass, on_delete=models.SET_NULL, null=True)
    parent_name = models.CharField(max_length=200)
    parent_phone = models.CharField(max_length=50)
    submitted_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default='pending')
    notes = models.TextField(blank=True)
    def __str__(self): return f"{self.full_name} - {self.desired_class}"
