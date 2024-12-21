from django import forms
from .models import Address, DevicesType,Device,Discount,Inventory,Payment,Plan,SubcriptionVisit,Subscription,TecnicalVisit,PlanSubscription,UserVisit

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
        fields = ['device_type', 'inventory', 'plan', 'installation_date', 'serial_number']
    
    installation_date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))

    serial_number = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
        'id': 'exampleFormControlTextarea'
    }))

class ItemFormDiscount(forms.ModelForm):
    class Meta:
        model = Discount
        fields = ['password', 'percent', 'start_date', 'end_date', 'active']
    
    password = forms.CharField(widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    percent = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

    start_date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))
    end_date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))

    # active = forms.BooleanField(widget=forms.Bo(attrs={
    #     'class': 'form-control',
    #     'rows': 3,
    # }))

class ItemFormInventory(forms.ModelForm):
    class Meta:
        model = Inventory
        fields = ['address', 'quantity']

    quantity = forms.IntegerField(widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'rows': 3,
    }))

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
        fields = ['user', 'discount', 'start_date','end_date']

    start_date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))
    
    end_date = forms.DateTimeField(widget=forms.DateTimeInput(attrs={'class': 'datetimepicker'}))

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

class ItemFormUserVisit(forms.ModelForm):
    class Meta:
        model = UserVisit
        fields = ['user', 'tecnical_visit']