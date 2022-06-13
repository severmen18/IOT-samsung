-- upgrade --
CREATE TABLE IF NOT EXISTS "address" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "x" VARCHAR(400) NOT NULL,
    "y" VARCHAR(400) NOT NULL
);
COMMENT ON COLUMN "address"."x" IS 'Первая позиция';
COMMENT ON COLUMN "address"."y" IS 'Вторая позиция';
COMMENT ON TABLE "address" IS 'хранить адрес';
CREATE TABLE IF NOT EXISTS "dryerbox" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "box_id" INT NOT NULL UNIQUE,
    "box_used_status" BOOL NOT NULL  DEFAULT False,
    "user_id" INT,
    "temp" VARCHAR(400) NOT NULL  DEFAULT '',
    "humidity" VARCHAR(400) NOT NULL  DEFAULT ''
);
COMMENT ON COLUMN "dryerbox"."temp" IS 'Температура';
COMMENT ON COLUMN "dryerbox"."humidity" IS 'Влажность';
COMMENT ON TABLE "dryerbox" IS 'Характеристики и состояние бокса';
CREATE TABLE IF NOT EXISTS "dryersystem" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "name_of_organization" VARCHAR(400) NOT NULL,
    "text_address" VARCHAR(400) NOT NULL,
    "address_id" INT NOT NULL
);
COMMENT ON COLUMN "dryersystem"."name_of_organization" IS 'Название организации';
COMMENT ON COLUMN "dryersystem"."text_address" IS 'Текстовое название адреса';
CREATE TABLE IF NOT EXISTS "aerich" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "version" VARCHAR(255) NOT NULL,
    "app" VARCHAR(100) NOT NULL,
    "content" JSONB NOT NULL
);
CREATE TABLE IF NOT EXISTS "dryersystem_dryerbox" (
    "dryersystem_id" INT NOT NULL REFERENCES "dryersystem" ("id") ON DELETE CASCADE,
    "dryerbox_id" INT NOT NULL REFERENCES "dryerbox" ("id") ON DELETE CASCADE
);
