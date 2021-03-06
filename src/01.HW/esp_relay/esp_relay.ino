#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

#include <SensingInfo.h>
#include <Enviroment.h>
#include <RelaySetting.h>
#include <Wifi.h>
//
#include <H3Dropbox.h>
#include <H3FileSystem.h>
//
#include <Relay.h>

#define DEBUG_MODE 1
/*
   해피호구의 웹사이트를 열을 포트 주소.
*/
#define WEB_PORT 12345

#define TIME_SNYCHRONIZE_SERVER1 "pool.ntp.org"
#define TIME_SNYCHRONIZE_SERVER2 "time.nist.gov"

void openSoftAP(Wifi* wifiInfo, bool hidden);
void openStation(Wifi* wifiInfo);

void addHandlerToServer();
void startServer();

ESP8266WebServer *server = nullptr;

H3Dropbox* box;
H3FileSystem* fileSystem;
//
SensingInfo* sensingInfo = nullptr;
Enviroment* enviroment = nullptr;
RelaySetting* relaySetting = nullptr;
Wifi* wifiInfo = nullptr;
Relay* relayController = nullptr;

int count = 0;
bool setWifiInfo = false;
String filePath = "/";

const char SENSING_INFO_FILENAME[] PROGMEM = DEFAULT_SENSINGINFO_FILENAME;
const char ENVIROMENT_FILENAME[] PROGMEM = DEFAULT_ENVIROMENT_FILENAME;
const char RELAYSETTING_FILENAME[] PROGMEM = DEFAULT_RELAYSETTING_FILENAME;
const char WIFI_INFO_FILENAME[] PROGMEM = DEFAULT_WIFI_FILENAME;

const char TIME_SERVER1[] PROGMEM = TIME_SNYCHRONIZE_SERVER1;
const char TIME_SERVER2[] PROGMEM = TIME_SNYCHRONIZE_SERVER2;

/*
    설정된 값들을 eeprom에서 읽어오는 함수
    ssid, password, bootmode 를 읽어 옴.
*/
void loadWifiInfo() {
  filePath += WiFi.softAPmacAddress();
  filePath.replace(":", "");

  WiFi.mode(WIFI_OFF);

  fileSystem = new H3FileSystem();
  wifiInfo = new Wifi(filePath, FPSTR(WIFI_INFO_FILENAME));
  fileSystem->download(dynamic_cast<Setting*>(wifiInfo));
  delete fileSystem;

  // flash에 configure 정보를 저장하지 않음.
  WiFi.persistent(false);
}

// 다운로드 드랍박스 데이터
bool downloadCurrentSetting() {
  box = new H3Dropbox(wifiInfo->getDropboxKey());
  delete wifiInfo;

  sensingInfo = new SensingInfo(filePath, FPSTR(SENSING_INFO_FILENAME));
  if ( !box->download(dynamic_cast<Setting*>(sensingInfo)) )
    return false;
  box->reversions(dynamic_cast<Setting*>(sensingInfo));
  box->requestLatestCursor(dynamic_cast<Setting*>(sensingInfo));

  enviroment = new Enviroment(filePath, FPSTR(ENVIROMENT_FILENAME));
  if ( !box->download(dynamic_cast<Setting*>(enviroment)) )
    return false;
  box->reversions(dynamic_cast<Setting*>(enviroment));

  relaySetting = new RelaySetting(filePath, FPSTR(RELAYSETTING_FILENAME));
  if ( !box->download(dynamic_cast<Setting*>(relaySetting)) )
    return false;
  box->reversions(dynamic_cast<Setting*>(relaySetting));

  relayController = new Relay();
  relayController->run(sensingInfo, enviroment, relaySetting);

  Serial.print("relay ready : ");
  Serial.println(ESP.getFreeHeap());

  return true;
}

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
    configTime(9 * 3600, 0, String(FPSTR(TIME_SERVER1)).c_str(), String(FPSTR(TIME_SERVER2)).c_str());
    for (int i = 0; i < 1000; i++) {
      delay(1);
    }
    Serial.print("setting : ");
    Serial.println(downloadCurrentSetting() ? "OK" : "FAIL");
  }
  else {
    server = new ESP8266WebServer(WEB_PORT);
    addHandlerToServer();
    startServer();
    Serial.print("server done : ");
    Serial.println(ESP.getFreeHeap());
  }
}

void loop() {
  if (server != nullptr) {
    if (!setWifiInfo) server->handleClient();
    else {
      Serial.println("begin restart!!");
      ESP.restart();
    }
  }
  else {
    Serial.println("start longPoll");
    if ( box->longPoll(dynamic_cast<Setting*>(sensingInfo), 30) ) {
      box->requestLatestCursor(dynamic_cast<Setting*>(sensingInfo));

      if ( box->isChangeReversions(dynamic_cast<Setting*>(sensingInfo)) ) {
        box->download(dynamic_cast<Setting*>(sensingInfo));
      }
      if ( box->isChangeReversions(dynamic_cast<Setting*>(enviroment)) ) {
        box->download(dynamic_cast<Setting*>(enviroment));
      }
      if ( box->isChangeReversions(dynamic_cast<Setting*>(relaySetting)) ) {
        box->download(dynamic_cast<Setting*>(relaySetting));
      }

      relayController->run(sensingInfo, enviroment, relaySetting);
      Serial.println("run relay");
    }
    //
    Serial.println(count++);
    Serial.print("crruent memory : ");
    Serial.println(ESP.getFreeHeap());
    //
  }
}
