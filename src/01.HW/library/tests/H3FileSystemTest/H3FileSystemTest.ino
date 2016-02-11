#include <ESP8266WiFi.h>

#include "SensingInfo.h"
#include "Enviroment.h"
#include "Relay.h"
#include "Wifi.h"
#include "H3FileSystem.h"

#define UPLOAD_TEST 0
#define FORMAT true

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.setDebugOutput(false);
  WiFi.mode(WIFI_OFF);
  Serial.println("done");

  Serial.println(ESP.getFreeHeap());
  Serial.println("start format");
  H3FileSystem fs(FORMAT);
  Serial.print("create file system : ");
  Serial.println(ESP.getFreeHeap());

  String mac = WiFi.softAPmacAddress();
  mac.replace(":", "");
  String filePath = "/" + mac;
  Serial.println(filePath);
  
  if (UPLOAD_TEST) {
    Serial.println("upload TEST--------------------------------");

    SensingInfo sensing(filePath, "/sensing.json");
    Serial.println("fs.upload(dynamic_cast<Setting*>(&sensing)) test .... ");
    Serial.println( (fs.upload(dynamic_cast<Setting*>(&sensing)) == 0) ? "OK" : "FAIL");
    Serial.println();

    Enviroment enviroment(filePath, "/enviroment.json");
    Serial.println("fs.upload(dynamic_cast<Setting*>(&enviroment)) test .... ");
    Serial.println( (fs.upload(dynamic_cast<Setting*>(&enviroment)) == 0) ? "OK" : "FAIL");
    Serial.println();

    Relay relay(filePath, "/relay.json");
    Serial.println("fs.upload(dynamic_cast<Setting*>(&Relay)) test .... ");
    Serial.println( (fs.upload(dynamic_cast<Setting*>(&relay)) == 0) ? "OK" : "FAIL");
    Serial.println();

    Wifi wifi(filePath, "/wifi.json");
    Serial.println("fs.upload(dynamic_cast<Setting*>(&Wifi)) test .... ");
    Serial.println( (fs.upload(dynamic_cast<Setting*>(&wifi)) == 0) ? "OK" : "FAIL");
    Serial.println();
    
    Serial.println("End--------------------------------\n\n");
  } else {

    Serial.println("download TEST--------------------------------");

    uint32_t startTime = millis();
    SensingInfo sensing(filePath, "/sensing.json");
    Serial.println("fs.download(dynamic_cast<Setting*>(&sensing)) test .... ");
    Serial.println( (fs.download(dynamic_cast<Setting*>(&sensing)) == 0) ? "OK" : "FAIL");
    Serial.println(sensing.serialize());
    Serial.println();

    Enviroment enviroment(filePath, "/enviroment.json");
    Serial.println("fs.download(dynamic_cast<Setting*>(&enviroment)) test .... ");
    Serial.println( (fs.download(dynamic_cast<Setting*>(&enviroment)) == 0) ? "OK" : "FAIL");
    Serial.println(enviroment.serialize());
    Serial.println();

    Relay relay(filePath, "/relay.json");
    Serial.println("fs.download(dynamic_cast<Setting*>(&Relay)) test .... ");
    Serial.println( (fs.download(dynamic_cast<Setting*>(&relay)) == 0) ? "OK" : "FAIL");
    Serial.println(relay.serialize());
    Serial.println();

    Wifi wifi(filePath, "/wifi.json");
    Serial.println("fs.download(dynamic_cast<Setting*>(&Wifi)) test .... ");
    Serial.println( (fs.download(dynamic_cast<Setting*>(&wifi)) == 0) ? "OK" : "FAIL");
    Serial.println(wifi.serialize());
    Serial.println();

    uint32_t endTime = millis();

    Serial.println("End--------------------------------\n\n");
    Serial.print("running time : ");
    Serial.println( (endTime - startTime) / 1000 );
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(ESP.getFreeHeap());
  delay(5000);
}
