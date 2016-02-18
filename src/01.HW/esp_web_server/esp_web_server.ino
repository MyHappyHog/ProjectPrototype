#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

#include <Thread.h>
#include <ThreadController.h>

#include <SensingInfo.h>
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
FoodSchedule* foodSchedule = nullptr;
Wifi* wifiInfo = nullptr;

H3Scheduler* scheduler = nullptr;
Sensor* sensor = nullptr;

ThreadController controll = ThreadController();

Thread myThread = Thread();
Thread sensingThread = Thread();

int count = 0;
bool updateCursor = false;
bool setWifiInfo = false;
String filePath = "/";

const char SENSING_INFO_FILENAME[] PROGMEM = DEFAULT_SENSINGINFO_FILENAME;
const char FOODSCHEDULE_FILENAME[] PROGMEM = DEFAULT_FOODSCHEDULE_FILENAME;
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

  // 다운로드 안되면 디폴트값으로..
  fileSystem = new H3FileSystem();
  fileSystem->download(dynamic_cast<Setting*>(sensingInfo));
  if ( !box->upload(dynamic_cast<Setting*>(sensingInfo)) )
    return false;

  if ( !fileSystem->upload(dynamic_cast<Setting*>(sensingInfo)) )
    return false;
  delete fileSystem;

  foodSchedule = new FoodSchedule(filePath, FPSTR(FOODSCHEDULE_FILENAME));
  if ( !box->download(dynamic_cast<Setting*>(foodSchedule)) )
    return false;

  sensor = new Sensor();
  sensor->begin();
  Serial.print("begin done : ");
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

    myThread.onRun([]() {
      if (sensor->getRequireUpdate()) {
        Serial.print("upload SensingInfo : ");
        Serial.println(box->upload(dynamic_cast<Setting*>(sensingInfo)) ? "OK" : "FAIL");
        fileSystem = new H3FileSystem();
        fileSystem->upload(dynamic_cast<Setting*>(sensingInfo));
        delete fileSystem;
        sensor->setRequireUpdate(false);
      }

      bool changeCursor = false;
      if ( box->longPoll(dynamic_cast<Setting*>(sensingInfo), 30) ) {
        changeCursor = box->requestLatestCursor(dynamic_cast<Setting*>(sensingInfo));
        if ( box->isChangeReversions(dynamic_cast<Setting*>(foodSchedule)) ) {
          box->download(dynamic_cast<Setting*>(foodSchedule));
        }
      }

      scheduler = new H3Scheduler();
      scheduler->runSchedule(foodSchedule);
      delete scheduler;

      Serial.println(count++);
      Serial.print("crruent memory : ");
      Serial.println(ESP.getFreeHeap());

      updateCursor = changeCursor;
    });
    myThread.setInterval(35000);

    sensingThread.onRun([]() {
      sensor->Sensing(sensingInfo);
      Serial.println("sensing");
    });
    sensingThread.setInterval(2000);

    // Adds both threads to the controller
    controll.add(&myThread);
    controll.add(&sensingThread);
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
      delete server;
      server = nullptr;

      // 완료되었으면 WiFi 연결
      // 초기 세팅 적용.
      // 드랍박스에 초기 세팅 적용한 파일 생성
      WiFi.softAPdisconnect(true);

      openStation(wifiInfo);

      Serial.print("delete server : ");
      Serial.println(ESP.getFreeHeap());

      configTime(9 * 3600, 0, String(FPSTR(TIME_SERVER1)).c_str(), String(FPSTR(TIME_SERVER2)).c_str());
      for (int i = 0; i < 1000; i++) {
        delay(1);
      }

      Serial.print("setting : ");
      Serial.println(downloadCurrentSetting() ? "OK" : "FAIL");

      Serial.println("begin restart!!");
      ESP.restart();
    }
  }
  else {
    controll.run();

    if (updateCursor) {
      updateCursor = false;
      myThread.run();
    }
  }
}
