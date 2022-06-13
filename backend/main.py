from fastapi import FastAPI,  Query
from tortoise.contrib.fastapi import register_tortoise
from models.model import Address, DryerSystem, DryerBox
app = FastAPI()

global_system_status = 0
'''
    0 выключен 
    1 полностью включён 
    2 проветривание
'''

# @app.post('/get-all-ogranizations')
# async def ok():
#     result = []
#     z = await DryerSystem.all()
#     for one_system in z:
#         result.append({"id": one_system.id,
#                        "name":one_system.name_of_organization,
#                        "adress":one_system.text_address})
#     return result
import time
my_temp = 0
my_humidity = 0

@app.get('/get-temp')
async def get_temp():
    global my_humidity, my_temp
    return {
        "temp": str(my_temp),
        "humidity": my_humidity
    }
    # print(f"температура {temp} влажность {humidity}")

@app.get('/test')
async def test(temp: str, humidity:str):
    global my_humidity, my_temp
    my_humidity, my_temp = humidity, temp
    temp = temp
    print(f"температура {temp} влажность {humidity}")

    return global_system_status
@app.get("/set-status")
async def set_status(status: int):
    global global_system_status
    global_system_status = status
    return "ok"

@app.post("/add-dryer-system")
async def add_dryer_system(id_XY: int,
                           name_of_organization:str,
                           text_address:str):
    address = await Address.filter(id=id_XY).first()
    await DryerSystem.create(name_of_organization = name_of_organization,
                       address = address,
                       text_address = text_address)
    return "система создана"

@app.post("/add-dryer-box")
async def add_dryer_box(box_id: int):
    address = await DryerBox.create(box_id=box_id)
    return {"box id in db": str(address.id)}

@app.post("/comparison-box-and-system")
async def comparison_box_and_system(box_id_in_db: int, box_system_id:int):
    box_system =await DryerSystem.filter(id= box_system_id).first()
    one_box = await DryerBox.filter(id=box_id_in_db).first()
    await box_system.dryer_boxes.add(one_box)
    return "вроде добавилось"
@app.post("/add-XYadress")
async def add_XYadress(x: str, y:str):
    await Address.create(x=x, y=y)
    return "all ok"

register_tortoise(
    app,
    db_url="postgres://simba:simba@localhost:5432/iot",
    modules={"models": ["models.model", "aerich.models"]},
    generate_schemas=True,
    add_exception_handlers=True,
)
