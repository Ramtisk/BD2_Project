from django import forms
from .models import Address, DevicesType,Device,Discount,Payment,Plan,SubcriptionVisit,Subscription,TecnicalVisit,PlanSubscription,PlanDevice

class ItemFormAddress(forms.ModelForm):
    class Meta:
        model = Address
        fields = ['street', 'city', 'postal_code', 'country', 'user']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in ['street', 'city', 'postal_code', 'country']:
            self.fields[field_name].widget = forms.TextInput(attrs={
                'class': 'form-control',
                'id': f'{field_name}FormControlText',
            })

class ItemFormDevicesType(forms.ModelForm):
    class Meta:
        model = DevicesType
        fields = ['name', 'description', 'image']
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in ['name', 'description', 'image']:
            self.fields[field_name].widget = forms.TextInput(attrs={
                'class': 'form-control',
                'id': f'{field_name}FormControlText',
            })

class ItemFormDevice(forms.ModelForm):
    class Meta:
        model = Device
        fields = ['device_type', 'installation_date', 'serial_number']
        widgets = {
            'installation_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
        }

    installation_date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M'],
        widget=forms.DateTimeInput(attrs={'class': 'datepicker', 'type': 'datetime-local'})
    )

    serial_number = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))

class ItemFormDiscount(forms.ModelForm):
    class Meta:
        model = Discount
        fields = [ 'name','percent', 'active']
    
    name = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))
    
    price = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    percent = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

class ItemFormPlan(forms.ModelForm):
    class Meta:
        model = Plan
        fields = ['name','description', 'price', 'service_type']

    name = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))
    description = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))
    price = forms.FloatField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

class ItemFormSubscription(forms.ModelForm):
    class Meta:
        model = Subscription
        fields = ['user', 'discount', 'start_date', 'end_date']
        widgets = {
            'end_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
            'start_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
        }

    start_date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M'],
        widget=forms.DateTimeInput(attrs={'class': 'datepicker', 'type': 'datetime-local'})
    )
    
    end_date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M'],
        widget=forms.DateTimeInput(attrs={'class': 'datepicker', 'type': 'datetime-local'})
    )

class ItemFormPayment(forms.ModelForm):
    class Meta:
        model = Payment
        fields = ['subscription','user','amount','date','entity','refence']
        widgets = {
            'installation_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
        }

    amount = forms.FloatField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M'],
        widget=forms.DateTimeInput(attrs={'class': 'datepicker', 'type': 'datetime-local'})
    )
    entity = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))

    refence = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))

class ItemFormTecnicalVisit(forms.ModelForm):
    class Meta:
        model = TecnicalVisit
        fields = ['tecnical','device', 'note','date']
        widgets = {
            'installation_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
        }

    note = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextInput'
    }))

    date = forms.DateTimeField(
        input_formats=['%Y-%m-%dT%H:%M'],
        widget=forms.DateTimeInput(attrs={'class': 'datepicker', 'type': 'datetime-local'})
    )

class ItemFormSubcriptionVisit(forms.ModelForm):
    class Meta:
        model = SubcriptionVisit
        fields = ['subscription', 'tecnical_visit']

class ItemFormPlanDevice(forms.ModelForm):
    class Meta:
        model = PlanDevice
        fields = ['plan', 'device']
    
class ItemFormPlanSubscription(forms.ModelForm):
    class Meta:
        model = PlanSubscription
        fields = ['plan', 'subscription']