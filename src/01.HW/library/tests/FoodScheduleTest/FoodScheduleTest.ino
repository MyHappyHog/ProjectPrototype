#include <ESP8266WiFi.h>

#include "H3Dropbox.h"
#include "FoodSchedule.h"

#define UPLOAD_TEST 0

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.setDebugOutput(true);
  WiFi.begin("joh2", "jongho123");

  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  configTime(9 * 3600, 0, "pool.ntp.org", "time.nist.gov");

  Serial.println(WiFi.localIP());

  for (int i = 0; i < 1000; i++) {
    delay(1);
  }

  Serial.println("done");
  Serial.println(ESP.getFreeHeap());
  H3Dropbox box("ZNY3ZFrtCuAAAAAAAAAAklDRKrgOO_gppTu2E964CCE2fPe38B4tddtnqYB54Xdb");
  
  Serial.print("box create done : ");
  String mac = WiFi.softAPmacAddress();
  mac.replace(":", "");
  String filePath = "/" + mac;
  
  if (UPLOAD_TEST) {
    Serial.println("upload TEST--------------------------------");

    FoodSchedule foodSchedule(filePath, "/foodSchedule.json");
    Serial.print("foodSchedule create done : ");
    Serial.println(ESP.getFreeHeap());
    Serial.println("box.upload(dynamic_cast<Setting*>(&foodSchedule)) test .... ");
    Serial.println( box.upload(dynamic_cast<Setting*>(&foodSchedule)) ? "OK" : "FAIL");
    Serial.println();

    Serial.println("End--------------------------------\n\n");
  } else {

    Serial.println("download TEST--------------------------------");

    uint32_t startTime = millis();
    FoodSchedule foodSchedule(filePath, "/foodSchedule.json");
    Serial.println("box.download(dynamic_cast<Setting*>(&foodSchedule)) test .... ");
    Serial.println( box.download(dynamic_cast<Setting*>(&foodSchedule)) ? "OK" : "FAIL");
    Serial.println(foodSchedule.serialize());
    Serial.println();
    
    uint32_t endTime = millis();
    
    Serial.println("End--------------------------------\n\n");
    Serial.print("running time : ");
    Serial.println( endTime - startTime);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(ESP.getFreeHeap());
  delay(5000);
}
