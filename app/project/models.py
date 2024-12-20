from django.db import models
from django.contrib.auth.models import User


class Address(models.Model):
    address_id = models.AutoField(primary_key=True)
    street = models.TextField(blank=True, null=True)
    city = models.TextField(blank=True, null=True)
    postal_code = models.TextField(blank=True, null=True)
    country = models.TextField(blank=True, null=True)
    user = models.OneToOneField(User, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'address'


class Device(models.Model):
    device_id = models.AutoField(primary_key=True)
    device_type = models.ForeignKey('DevicesType', models.DO_NOTHING)
    inventory = models.ForeignKey('Inventory', models.DO_NOTHING)
    plan = models.ForeignKey('Plan', models.DO_NOTHING)
    installation_date = models.DateField(blank=True, null=True)
    serial_number = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'device'


class DevicesType(models.Model):
    device_type_id = models.AutoField(primary_key=True)
    name = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    image = models.TextField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'devices_type'


class Discount(models.Model):
    discount_id = models.AutoField(primary_key=True)
    password = models.CharField(max_length=256, blank=True, null=True)
    percent = models.IntegerField(blank=True, null=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    active = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'discount'
        

class Inventory(models.Model):
    inventory_id = models.AutoField(primary_key=True)
    address = models.ForeignKey(Address, models.DO_NOTHING)
    quantity = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'inventory'


class Payment(models.Model):
    payment_id = models.AutoField(primary_key=True)
    subscription = models.ForeignKey('Subscription', models.DO_NOTHING)
    user = models.ForeignKey(User, models.DO_NOTHING)
    amount = models.FloatField(blank=True, null=True)
    date = models.DateField(blank=True, null=True)
    entity = models.TextField(blank=True, null=True)
    refence = models.TextField(blank=True, null=True)
    api = models.TextField(blank=True, null=True)
    cell_number = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'payment'


class Plan(models.Model):
    plan_id = models.AutoField(primary_key=True)
    description = models.TextField(blank=True, null=True)
    price = models.FloatField(blank=True, null=True)
    service_type = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'plan'


class PlanSubscription(models.Model):
    plan = models.OneToOneField(Plan, models.DO_NOTHING, primary_key=True)
    subscription = models.ForeignKey('Subscription', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'plan_subscription'
        unique_together = (('plan', 'subscription'), ('plan', 'subscription'),)


class SubcriptionVisit(models.Model):
    subscription = models.OneToOneField('Subscription', models.DO_NOTHING, primary_key=True)
    tecnical_visit = models.ForeignKey('TecnicalVisit', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'subcription_visit'
        unique_together = (('subscription', 'tecnical_visit'), ('subscription', 'tecnical_visit'),)


class Subscription(models.Model):
    subscription_id = models.AutoField(primary_key=True)
    user = models.ForeignKey(User, models.DO_NOTHING)
    discount = models.ForeignKey(Discount, models.DO_NOTHING, blank=True, null=True)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'subscription'


class TecnicalVisit(models.Model):
    tecnical_visit_id = models.AutoField(primary_key=True)
    device = models.ForeignKey(Device, models.DO_NOTHING)
    note = models.TextField(blank=True, null=True)
    date = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'tecnical_visit'


class UserVisit(models.Model):
    user = models.OneToOneField(User, models.DO_NOTHING, primary_key=True)
    tecnical_visit = models.ForeignKey(TecnicalVisit, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'user_visit'
        unique_together = (('user', 'tecnical_visit'), ('user', 'tecnical_visit'),)
