#define ARG_NAME_SSID "ssid"
#define ARG_NAME_PASSWORD "password"
#define ARG_NAME_RELAY_MAC "relayMac"
#define ARG_NAME_DROPBOX_KEY "dropboxKey"

/*
   HTML 템플릿. String Object를 이용해서 <titleContent> 부분과 <bodyContent> 부분을
   replace 하여 사용.
*/
#define HTML_TEMPLATE \
  "<html>\
  <head><meta charset=\"UTF-8\">\
  <title> <titleContent> </title>\
  </head>\
  <body>\
  <bodyContent>\
  </body>\
</html>"

#define WIFI_FORM_TEMPLATE \
  "<form action=\"/\" method=\"POST\">\
  relay Mac : <input type=\"text\" name=\"<macContent>\"/><br/>\
  ssid : <input type=\"text\" name=\"<ssidContent>\"/><br/>\
  password : <input type=\"password\" name=\"<passwordContent>\"/><br/>\
  key : <input type=\"text\" name=\"<keyContent>\"/><br/>\
  <input type=\"submit\" value=\"설정하기\"/>\
</form>"

const char HTML[] PROGMEM = HTML_TEMPLATE;
const char WIFI_FORM[] PROGMEM = WIFI_FORM_TEMPLATE;

// 요청한 주소가 없을 때 요청을 한 주소와 args를 찍어서 보내줌..
//void handleNotFound() {
//  String message = "File Not Found\n\n";
//  message += "URI: ";
//  message += server->uri();
//  message += "\nMethod: ";
//  message += ( server->method() == HTTP_GET ) ? "GET" : "POST";
//  message += "\nArguments: ";
//  message += server->args();
//  message += "\n";
//
//  for ( uint8_t i = 0; i < server->args(); i++ ) {
//    message += " " + server->argName ( i ) + ": " + server->arg ( i ) + "\n";
//  }
//
//  server->send ( 404, "text/plain", message );
//}

void handleWifiConfig() {
  // WiFi 관련된 설정 적용
  //key = server->arg(ARG_NAME_DROPBOX_KEY);
  String key = "ZNY3ZFrtCuAAAAAAAAAAklDRKrgOO_gppTu2E964CCE2fPe38B4tddtnqYB54Xdb";

  WIFIData* wifiData = new WIFIData;
  wifiData->ssid = server->arg(ARG_NAME_SSID);
  wifiData->password = server->arg(ARG_NAME_PASSWORD);
  wifiData->dropboxKey = key;
  wifiInfo->setData(wifiData);

  // Relay에 연결하여 드랍박스 키 정보를 제공해줌으로써
  // 드랍박스에 직접 접속할 수 있도록 해줌.

//  server->send(200, "text/html; charset=utf-8", "완료되었습니다");
//  if (server != NULL) {
//    delete server;
//    server = NULL;
//  }
  // 완료되었으면 WiFi 연결
  // 초기 세팅 적용.
  // 드랍박스에 초기 세팅 적용한 파일 생성
  WiFi.softAPdisconnect(true);
  
  openStation(wifiInfo);
  
  Serial.print("after open station : ");
  Serial.println(ESP.getFreeHeap());
  
  fileSystem->upload(dynamic_cast<Setting*>(wifiInfo));

  configTime(9 * 3600, 0, "pool.ntp.org", "time.nist.gov");
  for (int i = 0; i < 1000; i++) {
    delay(1);
  }
//  box = new H3Dropbox(wifiData->dropboxKey);
//
//  Serial.print("after new box : ");
  Serial.println(ESP.getFreeHeap());
//  
  sensingInfo = new SensingInfo(filePath, "/sensingInfo.json");
//  box->upload(dynamic_cast<Setting*>(sensingInfo));
//
//  Serial.print("after new SensingInfo : ");
//  Serial.println(ESP.getFreeHeap());
//  
//  enviroment = new Enviroment(filePath, "/enviroment.json");
//  box->download(dynamic_cast<Setting*>(enviroment));
//
//  Serial.print("after new Enviroment : ");
//  Serial.println(ESP.getFreeHeap());
//  
//  foodSchedule = new FoodSchedule(filePath, "/foodSchedule.json");
//  box->download(dynamic_cast<Setting*>(foodSchedule));
//
//  Serial.print("after new FoodSchedule : ");
//  Serial.println(ESP.getFreeHeap());
//  
//  // 웹서버 종료.
//  // 다음부터는 웹서버는 열지 않도록 함.
//
//  scheduler = new H3Scheduler();
//  sensor = new Sensor();
//
//  Serial.print("after new device : ");
//  Serial.println(ESP.getFreeHeap());
//  
//  sensor->begin();
}

// Wifi form을 반환
//void handleShowWifiForm() {
//  // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
//  String formMessage = FPSTR(HTML);
//  formMessage.replace("<titleContent>", "MyHappyHog Init");
//  formMessage.replace("<bodyContent>", FPSTR(WIFI_FORM));
//  formMessage.replace("<macContent>", ARG_NAME_RELAY_MAC);
//  formMessage.replace("<ssidContent>", ARG_NAME_SSID);
//  formMessage.replace("<passwordContent>", ARG_NAME_PASSWORD);
//  formMessage.replace("<keyContent>", ARG_NAME_DROPBOX_KEY);
//
//  server->send(200, "text/html", formMessage);
//}
