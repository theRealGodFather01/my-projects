# Generated by Django 4.1.1 on 2022-11-19 03:59

import authy.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authy', '0006_alter_profile_picture'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='profile',
            name='bio',
        ),
        migrations.AddField(
            model_name='profile',
            name='profile_info',
            field=models.TextField(blank=True, max_length=150, null=True),
        ),
        migrations.AlterField(
            model_name='profile',
            name='picture',
            field=models.ImageField(blank=True, null=True, upload_to=authy.models.user_directory_path, verbose_name='Picture'),
        ),
    ]
