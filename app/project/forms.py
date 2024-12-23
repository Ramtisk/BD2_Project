from django import forms
from .models import Address, DevicesType,Device,Discount,Payment,Plan,SubcriptionVisit,Subscription,TecnicalVisit,PlanSubscription

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

    name = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea1'
    }))
    description = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea2'
    }))
    image = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control-file',
        'id': 'exampleFormControlFile1'
    }))

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

    serial_number = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))

class ItemFormDiscount(forms.ModelForm):
    class Meta:
        model = Discount
        fields = [ 'percent', 'start_date', 'end_date', 'active']
        widgets = {
            'start_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
            'end_date': forms.DateTimeInput(attrs={'class': 'datepicker'}, format='%Y-%m-%dT%H:%M'),
        }

    percent = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))
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
        fields = ['subscription','user','amount','date','entity','refence','api','cell_number']

    amount = forms.FloatField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))

    entity = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))

    refence = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))

    api = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))
    
    cell_number = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

class ItemFormPlan(forms.ModelForm):
    class Meta:
        model = Plan
        fields = ['description', 'price', 'service_type']

    price = forms.FloatField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    description = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))
    
    service_type = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

class ItemFormPlanSubscription(forms.ModelForm):
    class Meta:
        model = PlanSubscription
        fields = ['plan', 'subscription']
    
class ItemFormSubcriptionVisit(forms.ModelForm):
    class Meta:
        model = SubcriptionVisit
        fields = ['subscription', 'tecnical_visit']

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

class ItemFormTecnicalVisit(forms.ModelForm):
    class Meta:
        model = TecnicalVisit
        fields = ['device', 'note','date']

    note = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))

    date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))