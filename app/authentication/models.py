from django.db import models

class User(models.Model):
    username = models.CharField(max_length=150, unique=True)
    password = models.CharField(max_length=128)
    user_type = models.CharField(max_length=50, choices=[('admin', 'Admin'), ('forn', 'Fornecedor'), ('client', 'Cliente')])

    def __str__(self):
        return self.username
