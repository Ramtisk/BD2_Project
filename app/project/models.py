from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator

class Address(models.Model):
    address_id = models.AutoField(primary_key=True)
    street = models.TextField()
    city = models.TextField()
    postal_code = models.TextField()
    country = models.TextField()
    user = models.OneToOneField(User, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'address'

class DevicesType(models.Model):
    device_type_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    image = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'devices_type'

class Device(models.Model):
    device_id = models.AutoField(primary_key=True)
    device_type = models.ForeignKey(DevicesType, models.DO_NOTHING)
    installation_date = models.DateTimeField(blank=True, null=True)
    serial_number = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'device'

class Discount(models.Model):
    discount_id = models.AutoField(primary_key=True)
    name = models.TextField(unique=True)
    percent = models.IntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(100)]
    )
    active = models.BooleanField(default=True)

    class Meta:
        managed = True
        db_table = 'discount'

class Plan(models.Model):
    plan_id = models.AutoField(primary_key=True)
    name = models.TextField()
    description = models.TextField(blank=True, null=True)
    price = models.FloatField(validators=[MinValueValidator(0.01)])
        
    SERVICE_TYPE_CHOICES = [
        ('Telemovel', 'Telemovel'),
        ('Internet', 'Internet'),
        ('TV', 'TV'),
        ('Telefone', 'Telefone'),
    ]
    
    service_type = models.CharField(
        max_length=10,
        choices=SERVICE_TYPE_CHOICES,
    )

    class Meta:
        managed = True
        db_table = 'plan'

class Subscription(models.Model):
    subscription_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, models.DO_NOTHING)
    discount = models.ForeignKey(Discount, models.DO_NOTHING, blank=True, null=True)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()

    class Meta:
        managed = True
        db_table = 'subscription'

class Payment(models.Model):
    payment_id = models.AutoField(primary_key=True)
    subscription = models.ForeignKey(Subscription, models.DO_NOTHING)
    user = models.ForeignKey(User, models.DO_NOTHING)
    amount = models.FloatField(blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    entity = models.TextField(blank=True, null=True)
    refence = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'payment'

class TecnicalVisit(models.Model):
    tecnical_visit_id = models.AutoField(primary_key=True)
    tecnical = models.ForeignKey(User, models.DO_NOTHING)
    device = models.ForeignKey(Device, models.DO_NOTHING, blank=True, null=True)
    note = models.TextField()
    date = models.DateTimeField()

    class Meta:
        managed = True
        db_table = 'tecnical_visit'

class SubcriptionVisit(models.Model):
    subcription_visit_id = models.AutoField(primary_key=True)
    subscription = models.ForeignKey(Subscription, models.DO_NOTHING)
    tecnical_visit = models.ForeignKey(TecnicalVisit, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'subcription_visit'
        unique_together = (('subscription', 'tecnical_visit'), ('subscription', 'tecnical_visit'),)

class PlanDevice(models.Model):
    plan_device_id = models.AutoField(primary_key=True)
    plan = models.ForeignKey(Plan, models.DO_NOTHING)
    device = models.ForeignKey(Device, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'plan_device'

class PlanSubscription(models.Model):
    plan_subscription_id = models.AutoField(primary_key=True)
    plan = models.ForeignKey(Plan, models.DO_NOTHING)
    subscription = models.ForeignKey(Subscription, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'plan_subscription'