#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

#include "SensingInfo.h"
#include "Enviroment.h"
#include "Relay.h"
#include "Wifi.h"
#include "H3Dropbox.h"

#define UPLOAD_TEST 1

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.setDebugOutput(false);
  WiFi.begin("joh2", "jongho123");

  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  configTime(9 * 3600, 0, "pool.ntp.org", "time.nist.gov");

  Serial.println(WiFi.localIP());

  for (int i = 0; i < 2000; i++) {
    delay(1);
  }

  ESP8266WebServer* server = new ESP8266WebServer(80);
  delete server;
  
  Serial.println("done");
  Serial.println(ESP.getFreeHeap());
  H3Dropbox box("ZNY3ZFrtCuAAAAAAAAAAklDRKrgOO_gppTu2E964CCE2fPe38B4tddtnqYB54Xdb");
  Serial.print("box create done : ");
  String mac = WiFi.softAPmacAddress();
  mac.replace(":", "");
  String filePath = "/" + mac;
  if (UPLOAD_TEST) {
    Serial.println("upload TEST--------------------------------");

    SensingInfo sensing(filePath, "/sensing.json");
    Serial.print("sensing create done : ");
    Serial.println(ESP.getFreeHeap());
    Serial.println("box.upload(dynamic_cast<Setting*>(&sensing)) test .... ");
    Serial.println( (box.upload(dynamic_cast<Setting*>(&sensing))) ? "OK" : "FAIL");
    Serial.println();

    Enviroment enviroment(filePath, "/enviroment.json");
    Serial.println("box.upload(dynamic_cast<Setting*>(&enviroment)) test .... ");
    Serial.println( (box.upload(dynamic_cast<Setting*>(&enviroment))) ? "OK" : "FAIL");
    Serial.println();

    Relay relay(filePath, "/relay.json");
    Serial.println("box.upload(dynamic_cast<Setting*>(&Relay)) test .... ");
    Serial.println( (box.upload(dynamic_cast<Setting*>(&relay))) ? "OK" : "FAIL");
    Serial.println();

    Wifi wifi(filePath, "/wifi.json");
    Serial.println("box.upload(dynamic_cast<Setting*>(&Wifi)) test .... ");
    Serial.println( (box.upload(dynamic_cast<Setting*>(&wifi))) ? "OK" : "FAIL");
    Serial.println();

    Serial.println("End--------------------------------\n\n");
  } else {

    Serial.println("download TEST--------------------------------");

    uint32_t startTime = millis();
    SensingInfo sensing(filePath, "/sensing.json");
    Serial.println("box.download(dynamic_cast<Setting*>(&sensing)) test .... ");
    Serial.println( (box.download(dynamic_cast<Setting*>(&sensing))) ? "OK" : "FAIL");
    Serial.println(sensing.serialize());
    Serial.println();

    Enviroment enviroment(filePath, "/enviroment.json");
    Serial.println("box.download(dynamic_cast<Setting*>(&enviroment)) test .... ");
    Serial.println( (box.download(dynamic_cast<Setting*>(&enviroment))) ? "OK" : "FAIL");
    Serial.println(enviroment.serialize());
    Serial.println();

    Relay relay(filePath, "/relay.json");
    Serial.println("box.download(dynamic_cast<Setting*>(&Relay)) test .... ");
    Serial.println( (box.download(dynamic_cast<Setting*>(&relay))) ? "OK" : "FAIL");
    Serial.println(relay.serialize());
    Serial.println();

    Wifi wifi(filePath, "/wifi.json");
    Serial.println("box.download(dynamic_cast<Setting*>(&Wifi)) test .... ");
    Serial.println( (box.download(dynamic_cast<Setting*>(&wifi))) ? "OK" : "FAIL");
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
