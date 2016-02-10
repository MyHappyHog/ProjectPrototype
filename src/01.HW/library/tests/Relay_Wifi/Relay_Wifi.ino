#include "Relay.h"
#include "Wifi.h"

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  Serial.println("Relay TEST--------------------------------");
  Relay test("/relay.json");

  Setting* p = dynamic_cast<Setting*>(&test);
  if ( p != NULL ) {
    Serial.print("filePath : ");
    Serial.println(p->getFilePath());
    Serial.print("fileName : ");
    Serial.println(p->getFileName());
  }

  String json = "{\"temperature\":[2,1], \"humidity\":[1,0]}";

  Serial.println("original string");
  Serial.println(json);

  Serial.println("default data");
  Serial.println(test.serialize());

  Serial.println("update data");
  if ( test.deserialize(json) == 0 ) {
    Serial.println(test.serialize());
  } else {
    Serial.println("deserialize errer");
  }
  Serial.println("End--------------------------------\n\n");

  Serial.println("Wifi TEST--------------------------------");
  Wifi test2("/configure", "/wifi.json");

  p = dynamic_cast<Setting*>(&test2);
  if ( p != NULL ) {
    Serial.print("filePath : ");
    Serial.println(p->getFilePath());
    Serial.print("fileName : ");
    Serial.println(p->getFileName());
  }
  String json2 = "{\"ssid\":\"test\", \"password\":\"test_password\", \"boxkey\":\"test_dropbox_key\"}";

  Serial.println("original string");
  Serial.println(json2);

  Serial.println("default data");
  Serial.println(test2.serialize());

  Serial.println("update data");
  if ( test2.deserialize(json2) == 0 ) {
    Serial.println(test2.serialize());
  } else {
    Serial.println("deserialize errer");
  }
  Serial.println("End--------------------------------\n\n");
}

void loop() {
  // put your main code here, to run repeatedly:

}

