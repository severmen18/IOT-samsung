from tortoise.models import Model
from tortoise import fields
from datetime import datetime
from tortoise.contrib.postgres.indexes import HashIndex

class DryerSystem(Model):
    #список боксов
    #название организации
    dryer_boxes = fields.ManyToManyField('models.DryerBox', on_delete='CASCADE')
    name_of_organization = fields.CharField(max_length=400, null=False, description="Название организации")
    address = fields.ForeignKeyField('models.Address', on_delete='CASCADE', db_constraint=False,)
    text_address = fields.CharField(max_length=400, null=False, description="Текстовое название адреса")

    def __str__(self):
        return self.name_of_organization
class DryerBox(Model):
    """
     Характеристики и состояние бокса
    """
    box_id = fields.IntField(null=False, unique=True)
    box_used_status = fields.BooleanField(default=False)
    user_id = fields.IntField(null=True)
    temp = fields.CharField(max_length=400, default="",  description="Температура")
    humidity = fields.CharField(max_length=400,  default="", description="Влажность")
class Address(Model):
    '''
        хранить адрес
    '''
    x = fields.CharField(max_length=400, null=False, description="Первая позиция")
    y = fields.CharField(max_length=400,null=False,  description="Вторая позиция")

    def __str__(self):
        return f"x={self.x} y={self.y}"