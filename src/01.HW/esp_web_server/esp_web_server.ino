#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

#include <ArduinoJson.h>
#include <H3Dropbox.h>

#include <DHT.h>
#include <Stepper.h>

extern "C" {
#include "user_interface.h"
}

#define DEBUG_MODE 0

/*
   EEPROM에서 사용할 size. 아마도.. 20KB까지 가능하지 않나 생각됨.
   ESP-12E 의 flash size 는 4MB임. 아래는 참고자료
   https://github.com/esp8266/Arduino/blob/master/tools/sdk/ld/eagle.flash.4m.ld
   https://github.com/esp8266/Arduino/blob/master/tools/sdk/ld/eagle.flash.4m1m.ld
*/
#define EEPROM_SIZE 512

/*
   해피호구의 웹사이트를 열을 포트 주소.
*/
#define WEB_PORT 12345

#define DHT11_PIN_1 5
#define DHT11_PIN_2 4

#define STEP_IN_1 16
#define STEP_IN_2 14
#define STEP_IN_3 12
#define STEP_IN_4 13

#define MOTER_STEP 200

#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 10   // percent of trimmed mean

void openSoftAP(String& ssid, String& password, bool hidden);
void openStation(String& ssid, String& password);

void addHandlerToServer();
void startServer();

void handleNotFound();
void handlePutFood();
void handleShowWifiForm();
void handleWifiConfig();

void checkTemData(double* temp, int i);      // storing on the array
void checkHumData(double* humid, int i);
void printDHTData(double temp, double humid);

double findMean(double arr[]);                // finding mean value
double findMedian(double arr[]);              // sorting in ascending power and finding median value
double findTrimmed(double arr[], double percent);  // cut-off TRIM_PERCENT up and down
double zScore(double arr[]);                  // if not zScore range, put in median value
double nomalization(double* tempOrHumid);     // return final nomalization value
void sort(double arr[], int num);

/* 와이파이 ssid 와 password */
String ssid;
String password;
String relay_mac;
String mac;
String key = "";

double temperature[NUM_OF_DATA];
double humidity[NUM_OF_DATA];

int count = 0;
int countNum = NUM_OF_DATA / 2;   // parameters per sensor
double temp, humid;  // final nomalization value
float celsiustemp = 0;
uint32_t lastreadtime = millis();

ESP8266WebServer *server;
DHT dht1(DHT11_PIN_1, DHT11);
DHT dht2(DHT11_PIN_2, DHT11);
Stepper motor(MOTER_STEP, STEP_IN_1, STEP_IN_2, STEP_IN_3, STEP_IN_4);
H3Dropbox box("/helloworld", key);

/*
    설정된 값들을 eeprom에서 읽어오는 함수
    ssid, password, bootmode 를 읽어 옴.
*/
String loadConfigure() {

  ssid = "";
  password = "";
  mac = WiFi.softAPmacAddress();
  relay_mac = "";

  WiFi.mode(WIFI_OFF);
  // randomSeed(analogRead(A0));

  // flash에 configure 정보를 저장하지 않음.
  WiFi.persistent(false);

}

/*
    Serial을 연결하고 EEPROM의 설정을 로드함.
    EEPROM의 모드에 따라 AP 혹은 STATION 웹 서버를 엶.
*/
void setup() {
#ifdef DEBUG_MODE
  Serial.begin(115200);
#endif

  dht1.begin();
  dht2.begin();

#ifdef DEBUG_MODE
  Serial.setDebugOutput(true);
  Serial.println("start");
#endif

  loadConfigure();


  Serial.println(ssid);
  Serial.println(password);

  openSoftAP(mac, password, false);
  openStation(ssid, password);

  if (ssid.equals("")) {
    server = new ESP8266WebServer(WEB_PORT);
    addHandlerToServer();
    startServer();
  }
}

void loop() {
  if (server != NULL) server->handleClient();

  /*
    uint32_t currenttime = millis();
    if ( (currenttime - lastreadtime) > 2000 ) {

     /////////////////////////////////test
     //    Serial.print("inputArray");
     //   Serial.println();
     //   testingArray(temperature);
     ////////////////////////////////

     if (count >= countNum) {
       temp = nomalization(temperature);
       humid = nomalization(humidity);
       printDHTData(temp, humid);
       count = 0;

       if (server == NULL) {
         StaticJsonBuffer<200> jsonBuffer;
         JsonObject& root = jsonBuffer.createObject();
         root["temperature"] = temp;
         root["humidity"] = humid;
         String body;
         root.printTo(body);
         box.upload("sensingFile.txt", body);
       }
     }

     checkHumData(humidity, count);
     checkTemData(temperature, count);
     count++;

     lastreadtime = currenttime;
    #ifdef DEBUG_MODE
     Serial.print("softap mac address : ");
     Serial.println(WiFi.softAPmacAddress());

     Serial.print("sta mac address : ");
     Serial.println(WiFi.macAddress());
     Serial.println(system_get_free_heap_size());
    #endif
    }
  */
}
