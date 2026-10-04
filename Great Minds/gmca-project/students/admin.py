from django.contrib import admin
from .models import SchoolClass, Student, IntakeApplication

admin.site.register(SchoolClass)
admin.site.register(Student)
@admin.register(IntakeApplication)
class IntakeAdmin(admin.ModelAdmin):
    list_display = ('full_name', 'desired_class', 'status', 'submitted_at')
    list_filter = ('status', 'desired_class')
    search_fields = ('full_name', 'parent_name', 'parent_phone')