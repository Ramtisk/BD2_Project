from django import forms
from project.models import Device, DevicesType

class DeviceForm(forms.ModelForm):
    class Meta:
        model = Device
        fields = ['device_type', 'installation_date', 'serial_number']
        widgets = {
            'device_type': forms.Select(attrs={'class': 'form-control'}),
            'installation_date': forms.DateInput(attrs={'class': 'form-control', 'type': 'date'}),
            'serial_number': forms.TextInput(attrs={'class': 'form-control'}),
        }

class DevicesTypeForm(forms.ModelForm):
    class Meta:
        model = DevicesType
        fields = ['name', 'description', 'image']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Nome do dispositivo'}),
            'description': forms.Textarea(attrs={'class': 'form-control', 'rows': 4, 'placeholder': 'Descrição'}),
            'image': forms.TextInput(attrs={'class': 'form-control', 'rows': 4, 'placeholder': 'URL da imagem'}),
        }
