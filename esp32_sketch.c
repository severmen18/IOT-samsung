
#include <ESP32Servo.h>

#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#define INPUT_AIR_SERVO_PIN 25
#define OUTPUT_AIR_SERVO_PIN 26
#define POWER_AIR_SERVO_PIN 27

#define POWER_PWM_PIN_CHANEL 6
#define FUN_PIN 5
#define POWER_PIN 18
//инициализация серво моторов
Servo InputAirServo;
Servo OutputAirServo;
Servo PowerAirServo;
//конфигурация wi-fi
const char* ssid     = "my";
const char* password = "12345678";
//конфигурация wi-fi для json
String sensorReadings;
float sensorReadingsArr[3];
//иницализация латчика
#define SEALEVELPRESSURE_HPA (1013.25)
Adafruit_BME280 bme; // I2C



String serverName = "http://192.168.137.1:8000/test";
bool status;
void connect_wifi(){
   WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
 }
void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  connect_wifi();
  status = bme.begin(0x76); 
  InputAirServo.attach(INPUT_AIR_SERVO_PIN);
  OutputAirServo.attach(OUTPUT_AIR_SERVO_PIN);
  PowerAirServo.attach(POWER_AIR_SERVO_PIN);
  //подкючаемся к wi-fi
  //закрывает все серво
//  input_air_servo_motor_control(false);
  //настриваем пины
  pinMode(FUN_PIN, OUTPUT); 
  //канал частота глубина ШИП
  
  ledcSetup(POWER_PWM_PIN_CHANEL, 1000, 8);
  ledcAttachPin(POWER_PIN, POWER_PWM_PIN_CHANEL);
  
}
void all_power_on(){
    power_air_servo_motor_control(true);
    input_air_servo_motor_control(true);
    output_air_servo_motor_control(false);
    fun_control(true);
    ledcWrite(POWER_PWM_PIN_CHANEL , 6);
 }
void airing(){
    power_air_servo_motor_control(false);
    input_air_servo_motor_control(false);
    output_air_servo_motor_control(true);
    fun_control(true);
    ledcWrite(POWER_PWM_PIN_CHANEL , 0); 
}
void all_power_off(){
  power_air_servo_motor_control(false);
    input_air_servo_motor_control(true);
    output_air_servo_motor_control(false);
    fun_control(false);
    ledcWrite(POWER_PWM_PIN_CHANEL , 0); 
}
void loop() {
    if(WiFi.status()== WL_CONNECTED){
      float temp = bme.readTemperature();
      float humidity = bme.readHumidity();
      String serverPath = serverName + "?temp="+String(temp)+"&humidity="+String(humidity);
    
      sensorReadings = httpGETRequest(serverPath);
      Serial.println("Результат");
      if (sensorReadings == "0"){
        all_power_off();
        Serial.println("0");
      }
      if (sensorReadings == "1"){
        all_power_on();
        Serial.println("1");
      }
       if (sensorReadings == "2"){
        airing();
        Serial.println("2");
      }
      Serial.println(sensorReadings);

    }
    else {
      Serial.println("WiFi Disconnected");
    }

}
String httpGETRequest(String serverName) {
  WiFiClient client;
  HTTPClient http;
    
  // Your Domain name with URL path or IP address with path
  http.begin(client, serverName);
  
  // Send HTTP POST request
  int httpResponseCode = http.GET();
  
  String payload = "{}"; 
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

  return payload;
}


void power_air_servo_motor_control(bool open_){
// контролирет отурытие и закрытие нижнего серво мотора для новой порции воздуха
  if (open_){
    //открыть
    PowerAirServo.write(10);
  }else{
    PowerAirServo.write(155);
  }
}

void input_air_servo_motor_control(bool open_){
// контролирет отурытие и закрытие нижнего серво мотора для новой порции воздуха
  if (open_){
    //открыть
    InputAirServo.write(30);
  }else{
    InputAirServo.write(110);
  }
}
void output_air_servo_motor_control(bool open_){
// контролирет отурытие и закрытие нижнего серво мотора для новой порции воздуха
  if (open_){
    OutputAirServo.write(60);
  }else{
    OutputAirServo.write(150);
  }
}
void fun_control(bool fun_status){
  //включает или отключает вентилятор
     if(fun_status){
        digitalWrite(FUN_PIN, HIGH);
      }else{
         digitalWrite(FUN_PIN, LOW);
     }
}