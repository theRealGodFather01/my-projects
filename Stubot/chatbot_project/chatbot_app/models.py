from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.utils import timezone

class Level(models.Model):
    level_number = models.IntegerField(unique=True)

class Faculty(models.Model):
    abbreviation = models.CharField(max_length=10, unique=True)
    name = models.CharField(max_length=255, unique=True)

class Department(models.Model):
    abbreviation = models.CharField(max_length=10, unique=True)
    name = models.CharField(max_length=255, unique=True)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    program_type = models.CharField(max_length=50)  # Added program_type field
    degree_awarded = models.CharField(max_length=50)  # Added degree_awarded field

class Lecturer(models.Model):
    title = models.CharField(max_length=10, blank=True, null=True)
    first_name = models.CharField(max_length=255)
    middle_name = models.CharField(max_length=255, blank=True, null=True)
    last_name = models.CharField(max_length=255)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    lecturer_id = models.CharField(max_length=30, unique=True, blank=True, null=True)
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)

    def save(self, *args, **kwargs):
        # Generate lecturer_id
        if not self.lecturer_id:
            department_abbreviation = self.department.abbreviation
            name_initials = ''.join([name[0] for name in [self.first_name, self.middle_name, self.last_name] if name])
            lecturer_count = Lecturer.objects.filter(department=self.department).count()
            unique_number = f'{lecturer_count:03d}'  # Format the unique number with leading zeros

            self.lecturer_id = f'LCTR-{department_abbreviation}-{name_initials}-{unique_number}'

        super().save(*args, **kwargs)

class Agent(models.Model):
    agent_id = models.CharField(max_length=30, unique=True)
    first_name = models.CharField(max_length=255)
    middle_name = models.CharField(max_length=255, blank=True, null=True)
    last_name = models.CharField(max_length=255)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    
    def save(self, *args, **kwargs):
        # Generate agent_id
        if not self.agent_id:
            department_abbreviation = self.department.abbreviation
            name_initials = ''.join([name[0] for name in [self.first_name, self.middle_name, self.last_name] if name])
            agent_count = Agent.objects.filter(department=self.department).count()
            unique_number = f'{agent_count:03d}'  # Format the unique number with leading zeros

            self.agent_id = f'AGN-{department_abbreviation}-{name_initials}-{unique_number}'

        super().save(*args, **kwargs)

class Course(models.Model):
    SEMESTER_CHOICES = [
        ('first', 'First Semester'),
        ('second', 'Second Semester'),
    ]

    course_title = models.CharField(max_length=255)
    course_code = models.CharField(max_length=20, unique=True)
    level = models.ForeignKey(Level, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    is_core = models.BooleanField(default=True)
    credit_hours = models.IntegerField()
    lecturers = models.ManyToManyField(Lecturer)
    semester = models.CharField(max_length=10, choices=SEMESTER_CHOICES)

class Student(models.Model):
    registration_number = models.CharField(max_length=20, unique=True, blank=True, null=True)
    first_name = models.CharField(max_length=255)
    middle_name = models.CharField(max_length=255, blank=True, null=True)
    last_name = models.CharField(max_length=255, default='')
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)  # Added faculty field
    gpa = models.FloatField()
    cgpa = models.FloatField()
    is_full_time = models.BooleanField(default=True)
    mode_of_entry = models.CharField(max_length=50, choices=[('direct', 'Direct'), ('utme', 'UTME')])
    enrollment_year = models.IntegerField()
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)

    def save(self, *args, **kwargs):
        # Generate registration_number
        if not self.registration_number:
            faculty_abbreviation = self.department.faculty.abbreviation
            department_abbreviation = self.department.abbreviation
            unique_number = Student.objects.filter(department=self.department, enrollment_year=self.enrollment_year).count()
            unique_number = f'{unique_number:03d}'  # Format the unique number with leading zeros

            self.registration_number = f'{str(self.enrollment_year)[-2:]}/{faculty_abbreviation}/{department_abbreviation}/{unique_number}'

        super().save(*args, **kwargs)

class CustomUserManager(BaseUserManager):
    def create_user(self, email, phone_number, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, phone_number=phone_number, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, phone_number, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(email, phone_number, password, **extra_fields)

class User(AbstractBaseUser):
    id = models.BigAutoField(primary_key=True)
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_student = models.BooleanField(default=False)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['phone_number']

class Conversation(models.Model):
    STATUS_CHOICES = [
        ('settled', 'Settled'),
        ('not_settled', 'Not Settled'),
    ]

    conversation_id = models.CharField(max_length=20, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    start_timestamp = models.DateTimeField(auto_now_add=True)
    end_timestamp = models.DateTimeField(blank=True, null=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='not_settled')

    def end_conversation(self):
        self.end_timestamp = timezone.now()
        self.status = 'settled'
        self.save()

class Message(models.Model):
    message_id = models.CharField(max_length=20, unique=True)
    conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    sender = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

class Escalation(models.Model):
    ESCALATION_STATUS_CHOICES = [
        ('resolved', 'Resolved'),
        ('not_resolved', 'Not Resolved'),
    ]

    escalation_id = models.CharField(max_length=20, unique=True)
    conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)
    resolved = models.CharField(max_length=20, choices=ESCALATION_STATUS_CHOICES, default='not_resolved')

class AssignedAgents(models.Model):
    escalation = models.ForeignKey(Escalation, on_delete=models.CASCADE)
    agent = models.ForeignKey(Agent, on_delete=models.CASCADE)
    assignment_timestamp = models.DateTimeField(auto_now_add=True)

class Class(models.Model):
    name = models.CharField(max_length=255)
    students = models.ManyToManyField(Student)

class Event(models.Model):
    name = models.CharField(max_length=255)
    date = models.DateField()
    time = models.TimeField()
    location = models.CharField(max_length=255)

class News(models.Model):
    title = models.CharField(max_length=255)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

class CutoffMarks(models.Model):
    year = models.IntegerField()
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    cutoff_marks = models.FloatField()
