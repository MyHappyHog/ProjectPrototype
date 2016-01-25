#define ARG_NAME_SSID "ssid"
#define ARG_NAME_PASSWORD "password"

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
  "<form action=\"<UrlContent>\" method=\"<MethodContent>\">\
  ssid : <input type=\"text\" name=\"<ssidContent>\"/><br/>\
  password : <input type=\"password\" name=\"<passwordContent>\"/><br/>\
  <input type=\"submit\" value=\"변경하기\"/>\
  <moreContent> \
</form>"

const char HTML[] PROGMEM = HTML_TEMPLATE;
const char WIFI_FORM[] PROGMEM = WIFI_FORM_TEMPLATE;

// 메인화면을 출력해준다.
void handleRoot() {
  String rootText = FPSTR(HTML);
  rootText.replace("<titleContent>", "ESP8266 Demo");
  rootText.replace("<bodyContent>", String("<h1>Hello from Happy Hedgehog house !!</h1>")
                   + "<h1>안녕하세요. 해피 호구 하우스입니다!!</h1>"
                   + "<p>Temperature: " + temp + ", Humidity: " + humid + "</p>");
  server->send(200, "text/html;", rootText);
}

// 요청한 주소가 없을 때 요청을 한 주소와 args를 찍어서 보내줌..
void handleNotFound() {
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
}

// 먹이 한번 분량을 준다.
void handlePutFood() {
  motor.setSpeed(10);
  motor.step(MOTER_STEP / 4); // 90도

  server->send(200);
}

/*
   setting 관련.. form 태그 이용. 변경하기 버튼 클릭시 리다이렉션 됨.
   리다이렉션시 POST메소드로 arg에 입력한 내용이 들어있음.
   TOOD : 허용하지 않는 입력 처리하기.
*/
void handleInitConfig() {
  // form 으로 전달된 데이터 중에서 아규먼트 이름이 ssid나 password 인 아규먼트를
  // ssid 와 password 로 assign 하고 eeprom을 업데이트.(write)
  ssid = server->arg(ARG_NAME_SSID);
  write_ssid_to_eeprom( FIRST_ADDRESS_OF_SSID, ssid );
  password = server->arg(ARG_NAME_PASSWORD);
  write_password_to_eeprom( FIRST_ADDRESS_OF_PASSWORD, password );

  // @@@@@@@@@@@ make it
  // 12345(라우트) 포트가 열려있는지 확인하는 기능.
  //

  // esp를 처음 실행시켰을 경우에는
  // 입력한 ssid와 password 를 가진 공유기로 접속하여
  // mdns 서버를 실행.
  if (bootMode == AP_BOOT_MODE) {
    // 이후에 상태 보존을 위해 eeprom에 상태 저장.
    // eeprom에 write 해야됨.
    bootMode = STATION_BOOT_MODE;
    EEPROM.write( IS_FIRST_BOOT, bootMode );
    EEPROM.commit();

    // softAP의 연결을 종료하고 WiFi를 끔.
    WiFi.softAPdisconnect();
    Serial.println( "close AP mode" );
    Serial.println( "" );

    // 인스턴스를 다시 만듦.
    if (server != NULL) {
      delete server;
    }
    server = new ESP8266WebServer(WEB_PORT);
    openStation();
    startServer();
  } else {
    Serial.println( "" );
    Serial.println( "change WIFI" );

    // 현재 WiFi 연결을 끊음.
    WiFi.disconnect();

    // Station모드로 새로운 ssid에 연결
    openStation();

    Serial.println( "" );
    Serial.println("HTTP server started");
  }

  // 설정된 ip 알려 줌.
  server->send(200, "text/html; charset=utf-8", "당신의 ip는" + WiFi.localIP());
}

// Setting Form을 반환
void handleShowSetting() {
  // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
  String formMessage = FPSTR(HTML);
  formMessage.replace("<titleContent>", "MyHappyHog Init");
  formMessage.replace("<bodyContent>", FPSTR(WIFI_FORM));
  formMessage.replace("<UrlContent>", server->uri());
  formMessage.replace("<MethodContent>", "POST");
  formMessage.replace("<ssidContent>", ARG_NAME_SSID);
  formMessage.replace("<passwordContent>", ARG_NAME_PASSWORD);
  formMessage.replace("<moreContent>", "");

  server->send(200, "text/html", formMessage);
}

void handleShowSettingPut() {
  // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
  String formMessage = FPSTR(HTML);
  formMessage.replace("<titleContent>", "MyHappyHog Init");
  formMessage.replace("<bodyContent>", FPSTR(WIFI_FORM));
  formMessage.replace("<UrlContent>", "/edit");
  formMessage.replace("<MethodContent>", "POST");
  formMessage.replace("<ssidContent>", ARG_NAME_SSID);
  formMessage.replace("<passwordContent>", ARG_NAME_PASSWORD);
  formMessage.replace("<moreContent>", "<input type=\"hidden\" name=\"_method\" value=\"put\"/>");

  server->send(200, "text/html", formMessage);
}

void handlePutIn() {
  if (server->arg("_method").equals("put")) {
    server->send(200, "text/html", "com in");
  } else {
    handleNotFound();
  }
}

