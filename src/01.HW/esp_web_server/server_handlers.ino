
// 메인화면 Test data들을 출력해준다.
void handleRoot() {
  String rootText = FPSTR(HTML);
  //temperature = random(15, 30);
  //humidity = random(30, 70);
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

void handleStep() {
  motor.setSpeed(15);
  motor.step(MOTER_STEP/4); // 90도
  server->send(200, "text/plain", "run 50 step");
}
/*
 * setting 관련.. form 태그 이용. 변경하기 버튼 클릭시 리다이렉션 됨.
 * 리다이렉션시 POST메소드로 arg에 입력한 내용이 들어있음.
 * TOOD : 허용하지 않는 입력 처리하기.
 */
void handleSettingForm() {
  if (server->method() == HTTP_POST) {
    // 입력된 내용을 스트링으로 만듦
    String message = "아래와 같이 설정 되었습니다.<br/>";
    for ( uint8_t i = 0; i < server->args(); i++) {
      String _argName = server->argName(i);
      String _arg = server->arg(i);

      // form 으로 전달된 데이터 중에서 아규먼트 이름이 ssid나 password 인 아규먼트를
      // ssid 와 password 로 assign 하고 eeprom을 업데이트.(write)
      if ( _argName.equals(ARG_NAME_SSID) ) {
        ssid = String( _arg );
        write_ssid_to_eeprom( FIRST_ADDRESS_OF_SSID, ssid );
      } else if ( _argName.equals(ARG_NAME_PASSWORD) ) {
        password = String( _arg );
        write_password_to_eeprom( FIRST_ADDRESS_OF_PASSWORD, password );
      }

      message += _argName + ": " + _arg + "<br/>";
    }

    // 입력된 내용 확인.. 나중엔 필요없을듯?
    server->send(200, "text/html; charset=utf-8", message);

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
      WiFi.softAPdisconnect( true );
      Serial.println( "close AP mode" );
      Serial.println( "" );

      // 인스턴스를 다시 만듦.
      if (server != NULL) {
        delete server;
        server = new ESP8266WebServer(WEB_PORT);
        openStation();
        startServer();
      }
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
  } else {
    // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
    String formMessage = FPSTR(HTML);
    formMessage.replace("<titleContent>", "MyHappyHog Setting");
    formMessage.replace("<bodyContent>", "<form action=\"" + server->uri() + "\" method=\"POST\">"
                        + "ssid : <input type=\"text\" name=\"" + ARG_NAME_SSID + "\"/><br/>"
                        + "password : <input type=\"password\" name=\"" + ARG_NAME_PASSWORD + "\"/><br/>"
                        + "<input type=\"submit\" value=\"변경하기\"/>"
                        + "</form>");
    server->send(200, "text/html", formMessage);
  }
}
