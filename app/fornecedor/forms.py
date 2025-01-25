from django import forms
from project.models import Device, DevicesType

class DeviceForm(forms.ModelForm):
    class Meta:
        model = Device
        fields = ['device_type', 'installation_date', 'serial_number']

class DevicesTypeForm(forms.ModelForm):
    class Meta:
        model = DevicesType
        fields = ['name', 'description', 'image']
