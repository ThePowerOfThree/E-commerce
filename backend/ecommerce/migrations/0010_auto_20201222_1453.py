# Generated by Django 3.1.4 on 2020-12-22 14:53

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ecommerce', '0009_auto_20201222_1450'),
    ]

    operations = [
        migrations.RenameField(
            model_name='order',
            old_name='products',
            new_name='product_objects',
        ),
    ]