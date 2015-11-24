
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <EEPROM.h>

#define HTML_TEMPLATE \
  "<html>\
  <head><meta charset=\"UTF-8\">\
  <title> <titleContent> </title>\
  </head>\
  <body>\
  <bodyContent>\
  </body>\
</html>"

#define WEB_PORT 12345
#define STATION_BOOT_MODE 0
#define AP_BOOT_MODE 1

/* 와이파이 ssid 와 password */
const char *ssid = "happyhog";
const char *password = "hog12345";

byte bootMode;

/* test 용 데이터 */
double temperature = 25.5;
double humidity = 35.5;

ESP8266WebServer server(WEB_PORT);

// 메인화면 Test data들을 출력해준다.
void handleRoot() {
  String rootText = HTML_TEMPLATE;
  rootText.replace("<titleContent>", "ESP8266 Demo");
  rootText.replace("<bodyContent>", String("<h1>Hello from Happy Hedgehog house !!</h1>")
                   + "<h1>안녕하세요. 해피 호구 하우스입니다!!</h1>"
                   + "<p>Temperature: " + temperature + ", Humidity: " + humidity + "</p>");
  server.send(200, "text/html;", rootText);
}

// setting 관련.. form 태그 이용
// 변경하기 버튼 클릭시 리다이렉션 됨.
// 리다이렉션시 POST메소드로 arg에 입력한 내용이 들어있음.
// TOOD : 허용하지 않는 입력 처리하기.
void handleSettingForm() {
  if (server.method() == HTTP_POST) {
    // 입력된 내용을 스트링으로 만듦
    String message = "입력하신 내용은 아래와 같습니다.<br/>";
    for ( uint8_t i = 0; i < server.args(); i++) {
      message += server.argName(i) + ": " + server.arg(i) + "<br/>";
    }

    // 입력된 내용 확인.. 나중엔 필요없을듯?
    server.send(200, "text/html; charset=utf-8", message);

    // esp를 처음 실행시켰을 경우에는
    // 입력한 ssid와 password 를 가진 공유기로 접속하여
    // mdns 서버를 실행.
    if (bootMode == AP_BOOT_MODE) {
      // 이후에 상태 보존을 위해 eeprom에 상태 저장.
      // eeprom에 write 해야됨.
      bootMode = STATION_BOOT_MODE;
      EEPROM.write(511, bootMode);
      EEPROM.commit();

      // 현재 모드 disconnect
      WiFi.disconnect();
      WiFi.mode( WIFI_OFF );

      // 이전 server 클래스에 등록한 handler를 지울 방법이 없으므로..
      // 인스턴스를 다시 만듦.
      server = ESP8266WebServer(WEB_PORT);
      openStation();
      startServer();
    }
  } else {
    // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
    String formMessage = HTML_TEMPLATE;
    formMessage.replace("<titleContent>", "MyHappyHog Setting");
    formMessage.replace("<bodyContent>", "<form action=\"" + server.uri() + "\" method=\"POST\">"
                        + "ssid : <input type=\"text\" name=\"ssid\"/><br/>"
                        + "password : <input type=\"password\" name=\"password\"/><br/>"
                        + "<input type=\"submit\" value=\"변경하기\"/>"
                        + "</form>");
    server.send(200, "text/html", formMessage);
  }
}

// 요청한 주소가 없을 때 요청을 한 주소와 args를 찍어서 보내줌..
void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += ( server.method() == HTTP_GET ) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";

  for ( uint8_t i = 0; i < server.args(); i++ ) {
    message += " " + server.argName ( i ) + ": " + server.arg ( i ) + "\n";
  }

  server.send ( 404, "text/plain", message );
}

// AP 모드로 Server 열기
void openSoftAP() {
  Serial.print("Configuring access point...");
  WiFi.softAP(ssid, password);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);

  // Root Url 과 not found 핸들러 등록
  server.on("/", handleSettingForm);
  server.onNotFound ( handleNotFound );
}

// Station 모드로 공유기를 이용하여 mdns 서버 열기
void openStation() {
  Serial.println("Configuring station mode...");
  WiFi.begin ( "kmucs" );

  // Wait for connection
  if ( WiFi.waitForConnectResult() == WL_CONNECTED ) {
    Serial.println ( "WiFi Connected" );
  }
  
  Serial.println ( "" );
  Serial.print ( "Connected to " );
  Serial.println ( ssid );
  Serial.print ( "IP address: " );
  Serial.println ( WiFi.localIP() );

  // mdns 열기
  if ( MDNS.begin ( "esp8266" ) ) {
    Serial.println ( "esp8266 MDNS responder started" );
  }

  // 서버의 url 주소 핸들링
  server.on ( "/", handleRoot );
  server.on ( "/setting", handleSettingForm );
  server.onNotFound ( handleNotFound );

  // Add service to MDNS-SD
  MDNS.addService("http", "tcp", WEB_PORT);
}

void startServer() {
  server.begin();

  Serial.println("HTTP server started");
}

void setup() {
  delay(1000);
  Serial.begin(115200);
  Serial.println();

  EEPROM.begin(512);
  bootMode = EEPROM.read(511);

  // 모드에 따라 다른 서버를 엶.
  switch (bootMode) {
    case AP_BOOT_MODE:
      openSoftAP();
      break;
    case STATION_BOOT_MODE:
      openStation();
      break;
  }

  startServer();
}

void loop() {
  server.handleClient();
  delay(1000);
}
