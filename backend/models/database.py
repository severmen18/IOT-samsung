TORTOISE_ORM = {
    "connections": {"default": "postgres://simba:simba@localhost:5432/iot"},
    "apps": {
        "models": {
            "models": ["model",  "aerich.models"],
            "default_connection": "default",
        },
    },
}