#define ARG_NAME_SSID "ssid"
#define ARG_NAME_PASSWORD "password"
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
  ssid : <input type=\"text\" name=\"<ssidContent>\"/><br/>\
  password : <input type=\"password\" name=\"<passwordContent>\"/><br/>\
  key : <input type=\"text\" name=\"<keyContent>\"/><br/>\
  <input type=\"submit\" value=\"설정하기\"/>\
</form>"

const char HTML[] PROGMEM = HTML_TEMPLATE;
const char WIFI_FORM[] PROGMEM = WIFI_FORM_TEMPLATE;

void addHandlerToServer() {
  // Wifi form을 반환
  server->on ( "/", HTTP_GET, []() {
    // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
    String formMessage = FPSTR(HTML);
    formMessage.replace("<titleContent>", "MyHappyHog Init");
    formMessage.replace("<bodyContent>", FPSTR(WIFI_FORM));
    formMessage.replace("<ssidContent>", ARG_NAME_SSID);
    formMessage.replace("<passwordContent>", ARG_NAME_PASSWORD);
    formMessage.replace("<keyContent>", ARG_NAME_DROPBOX_KEY);

    server->send(200, "text/html", formMessage);
  });

  server->on ( "/", HTTP_POST, []() {
    // WiFi 관련된 설정 적용
    //key = server->arg(ARG_NAME_DROPBOX_KEY);
    WIFIData* wifiData = new WIFIData;

    {
      String key = "ZNY3ZFrtCuAAAAAAAAAAklDRKrgOO_gppTu2E964CCE2fPe38B4tddtnqYB54Xdb";

      wifiData->ssid = server->arg(ARG_NAME_SSID);
      wifiData->password = server->arg(ARG_NAME_PASSWORD);
      wifiData->dropboxKey = key;
    }

    fileSystem = new H3FileSystem();
    wifiInfo = new Wifi(filePath, FPSTR(WIFI_INFO_FILENAME));
    wifiInfo->setData(wifiData);

    fileSystem->upload(dynamic_cast<Setting*>(wifiInfo));
    delete fileSystem;

    // Relay에 연결하여 드랍박스 키 정보를 제공해줌으로써
    // 드랍박스에 직접 접속할 수 있도록 해줌.

    Serial.print("before open station : ");
    Serial.println(ESP.getFreeHeap());
    setWifiInfo = true;
    server->send(200);
  });

  // 요청한 주소가 없을 때 요청을 한 주소와 args를 찍어서 보내줌..
  server->onNotFound ( []() {
    String message = "File Not Found\n\n";
    message += "URI: ";
    message += server->uri();
    message += "\nMethod: ";
    message += ( server->method() == HTTP_GET ) ? "GET" : "POST";
    message += "\nArguments: ";
    message += server->args();
    message += "\n";

    for ( uint8_t i = 0; i < server->args(); i++ ) {
      message += " " + server->argName ( i ) + ": " + server->arg ( i ) + "\n";
    }

    server->send ( 404, "text/plain", message );
  });
}
