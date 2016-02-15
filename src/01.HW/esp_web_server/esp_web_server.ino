#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

#include <SensingInfo.h>
#include <Enviroment.h>
#include <FoodSchedule.h>
#include <Wifi.h>
//
#include <H3Dropbox.h>
#include <H3FileSystem.h>
//
#include <H3Scheduler.h>
#include <Sensor.h>

//#define DEBUG_MODE 1
/*
   해피호구의 웹사이트를 열을 포트 주소.
*/
#define WEB_PORT 12345

void openSoftAP(Wifi* wifiInfo, bool hidden);
void openStation(Wifi* wifiInfo);

void addHandlerToServer();
void startServer();

void handleNotFound();
void handleShowWifiForm();
void handleWifiConfig();

ESP8266WebServer *server = nullptr;

H3Dropbox* box;
H3FileSystem* fileSystem;
//
SensingInfo* sensingInfo;
Enviroment* enviroment;
FoodSchedule* foodSchedule;
Wifi* wifiInfo;

H3Scheduler* scheduler;
Sensor* sensor;

String filePath = "/";

/*
    설정된 값들을 eeprom에서 읽어오는 함수
    ssid, password, bootmode 를 읽어 옴.
*/
String loadWifiInfo() {
  filePath += WiFi.softAPmacAddress();
  filePath.replace(":", "");

  WiFi.mode(WIFI_OFF);
  fileSystem = new H3FileSystem();
  wifiInfo = new Wifi(filePath, "/wifiInfo.json");
  if (!fileSystem->download(dynamic_cast<Setting*>(wifiInfo))) {
#ifdef DEBUG_MODE
    Serial.println("wifi info load fail");
#endif
  }
  // flash에 configure 정보를 저장하지 않음.
  WiFi.persistent(false);
}

/*
    Serial을 연결하고 EEPROM의 설정을 로드함.
    EEPROM의 모드에 따라 AP 혹은 STATION 웹 서버를 엶.
*/
void setup() {
  Serial.begin(115200);
  Serial.print("begin memory : ");
  Serial.println(ESP.getFreeHeap());
#ifdef DEBUG_MODE
#endif

#ifdef DEBUG_MODE
  Serial.setDebugOutput(true);
  Serial.println("start");
#endif

  loadWifiInfo();

  openSoftAP(wifiInfo, false);
  openStation(wifiInfo);

  if (WiFi.status() == WL_CONNECTED) {
    configTime(9 * 3600, 0, "pool.ntp.org", "time.nist.gov");
    for (int i = 0; i < 1000; i++) {
      delay(1);
    }
//
    Serial.println(ESP.getFreeHeap());
    box = new H3Dropbox(wifiInfo->getDropboxKey());
    Serial.println("create dropbox");
    Serial.println(wifiInfo->getDropboxKey());
    Serial.println(ESP.getFreeHeap());
//
    Serial.println(ESP.getFreeHeap());
    sensingInfo = new SensingInfo(filePath, "/sensingInfo.json");
    Serial.println("create SensingInfo");
    Serial.println(box->download(dynamic_cast<Setting*>(sensingInfo)) ? "OK" : "FAIL");

    Serial.println(ESP.getFreeHeap());
    enviroment = new Enviroment(filePath, "/enviroment.json");
    Serial.println("create Enviroment");
    Serial.println(box->download(dynamic_cast<Setting*>(enviroment)) ? "OK" : "FAIL");

    Serial.println(ESP.getFreeHeap());
    foodSchedule = new FoodSchedule(filePath, "/foodSchedule.json");
    Serial.println("create FoodSchedule");
    Serial.println(box->download(dynamic_cast<Setting*>(foodSchedule)) ? "OK" : "FAIL");

    Serial.println(ESP.getFreeHeap());
    scheduler = new H3Scheduler();
    sensor = new Sensor();

    sensor->begin();
    // 다운로드 드랍박스 데이터
  }
  else {
    server = new ESP8266WebServer(WEB_PORT);
    addHandlerToServer();
    startServer();
  }
}

void loop() {
  if (server != nullptr) server->handleClient();
//  else {
//    ESP.getFreeHeap();
//    sensor->Sensing(sensingInfo);
//    if (sensor->getRequireUpdate()) {
//      box->upload(dynamic_cast<Setting*>(sensingInfo));
//      sensor->setRequireUpdate(false);
//    }
//  }
  delay(1000);
  Serial.println(ESP.getFreeHeap());
}
