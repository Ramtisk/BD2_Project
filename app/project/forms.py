from django import forms
from .models import DevicesType

class ItemForm(forms.ModelForm):
    class Meta:
        model = DevicesType
        fields = ['name', 'description','image']