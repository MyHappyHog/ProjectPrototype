#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <EEPROM.h>
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
   각 데이터들이 들어있는 주소. 여러 주소에 걸쳐있는 데이터인 경우에는
   데이터의 가장 첫 주소의 위치를 가르킴.
   FIRST_ADDRESS_OF_SSID : ssid의 데이터가 들어있는 주소. 맨 처음 주소는 ssid의 길이를 나타냄.
   FIRST_ADDRESS_OF_PASSWORD : password의 주소. 맨 처음 주소는 password의 길이를 나타냄.
   IS_FIRST_BOOT : 맨 초기의 부팅인지 확인하는 데이터가 들어있는 주소.
*/
#define FIRST_ADDRESS_OF_SSID 100
#define FIRST_ADDRESS_OF_PASSWORD 200
#define IS_FIRST_BOOT 500

/*
   해피호구의 웹사이트를 열을 포트 주소.
*/
#define WEB_PORT 12345

#define STATION_BOOT_MODE 0
#define AP_BOOT_MODE 1

#define DHT11_PIN_1 5
#define DHT11_PIN_2 4

#define STEP_IN_1 16
#define STEP_IN_2 14
#define STEP_IN_3 12
#define STEP_IN_4 13

#define MOTER_STEP 200

#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 10   // percent of trimmed mean

/* 함수 원형 선언 */
String read_ssid_from_eeprom( int firstAddress );
void write_ssid_to_eeprom( int address, String _ssid );
String read_password_from_eeprom( int firstAddress );
void write_password_to_eeprom(int address, String _password );

void openDualMode(String& mac, String& ssid, String& password);
void addHandlerToServer();
void startServer();

void handleNotFound();
void handleShowData();
void handleShowTable();
void handlePutFood();
void handleShowWifiForm();
void handleShowNewDataForm();
void handleShowEditDataForm();
void handleWifiConfig();
void handleNew();
void handleUpdate();
void handleDelete();

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
bool availableEditWifi;
String mac;
String relay_mac;

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
//Servo servo;
//boolean isCw = true;
//int pos = 180;

/*
    설정된 값들을 eeprom에서 읽어오는 함수
    ssid, password, bootmode 를 읽어 옴.
*/
String loadConfigure() {
  EEPROM.begin( EEPROM_SIZE );
  ssid = "";
  password = "";
  mac = WiFi.softAPmacAddress();
  relay_mac = "";
  //ssid = read_ssid_from_eeprom( FIRST_ADDRESS_OF_SSID );
  //password = read_password_from_eeprom( FIRST_ADDRESS_OF_PASSWORD );
  availableEditWifi = true;

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

  server = new ESP8266WebServer(WEB_PORT);

  Serial.println(ssid);
  Serial.println(password);

  openDualMode(mac, ssid, password);
  addHandlerToServer();
  startServer();
}

void loop() {
  server->handleClient();

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
