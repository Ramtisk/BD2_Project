from django import forms
from .models import DevicesType

class ItemFormDevicesType(forms.ModelForm):
    class Meta:
        model = DevicesType
        fields = ['name', 'description','image']

    name = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control', 'rows': 3, 'id': 'exampleFormControlTextarea1'
    }))
    description = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control', 'rows': 3, 'id': 'exampleFormControlTextarea2'
    }))
    image = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control-file', 'id': 'exampleFormControlFile1'
    }))