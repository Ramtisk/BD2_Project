# Generated by Django 3.1.3 on 2025-02-05 19:12

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=150, unique=True)),
                ('password', models.CharField(max_length=128)),
                ('user_type', models.CharField(choices=[('admin', 'Admin'), ('forn', 'Fornecedor'), ('client', 'Cliente')], max_length=50)),
            ],
        ),
    ]
