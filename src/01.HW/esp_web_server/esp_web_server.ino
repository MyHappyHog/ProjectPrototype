#include <ESP8266WiFi.h>
// 이 헤더는 수정됨. 윈도우 기준으로..
// C:\Users\<UserName>\AppData\Roaming\Arduino15\packages\esp8266\hardware\esp8266\2.0.0-rc2\libraries\ESP8266WebServer\src
// 내의 소스 코드를 깃허브 내에 이 코드 상위의 폴더에 있는 ESP8266WebServer.h and .cpp로 변경하길 바람..
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <EEPROM.h>

/*
 * HTML 템플릿. String Object를 이용해서 <titleContent> 부분과 <bodyContent> 부분을
 * replace 하여 사용.
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

/*
 * EEPROM에서 사용할 size. 아마도.. 20KB까지 가능하지 않나 생각됨.
 * ESP-12E 의 flash size 는 4MB임. 아래는 참고자료
 * https://github.com/esp8266/Arduino/blob/master/tools/sdk/ld/eagle.flash.4m.ld
 * https://github.com/esp8266/Arduino/blob/master/tools/sdk/ld/eagle.flash.4m1m.ld
 */
#define EEPROM_SIZE 512

/*
 * 각 데이터들이 들어있는 주소. 여러 주소에 걸쳐있는 데이터인 경우에는
 * 데이터의 가장 첫 주소의 위치를 가르킴.
 * FIRST_ADDRESS_OF_SSID : ssid의 데이터가 들어있는 주소. 맨 처음 주소는 ssid의 길이를 나타냄.
 * FIRST_ADDRESS_OF_PASSWORD : password의 주소. 맨 처음 주소는 password의 길이를 나타냄.
 * IS_FIRST_BOOT : 맨 초기의 부팅인지 확인하는 데이터가 들어있는 주소.
 */
#define FIRST_ADDRESS_OF_SSID 0
#define FIRST_ADDRESS_OF_PASSWORD 100
#define IS_FIRST_BOOT 511

#define ARG_NAME_SSID "ssid"
#define ARG_NAME_PASSWORD "password"
/*
 * 해피호구의 웹사이트를 열을 포트 주소.
 */
#define WEB_PORT 12345

#define STATION_BOOT_MODE 0
#define AP_BOOT_MODE 1

// server close state
#define CLOSE 0

/* 와이파이 ssid 와 password */
String ssid;
String password;

const char HTML[] PROGMEM = HTML_TEMPLATE;

byte bootMode;

/* test 용 데이터 */
double temperature = 25.5;
double humidity = 35.5;

ESP8266WebServer server(WEB_PORT);

/*
 *  설정된 값들을 eeprom에서 읽어오는 함수
 *  ssid, password, bootmode 를 읽어 옴.
 */
String loadConfigure() {
  EEPROM.begin( EEPROM_SIZE );
  ssid = read_ssid_from_eeprom( FIRST_ADDRESS_OF_SSID );
  password = read_password_from_eeprom( FIRST_ADDRESS_OF_PASSWORD );
  bootMode = EEPROM.read( IS_FIRST_BOOT );
}
/*
 *  EEPROM에서 ssid를 읽어들이는 함수
 */
String read_ssid_from_eeprom( int firstAddress ) {
  String read_ssid = String();
  int ssid_length = int(EEPROM.read(firstAddress++));

  for (int forLen = 0; forLen < ssid_length; forLen++) {
    read_ssid += char(EEPROM.read(firstAddress++));
  }
  return read_ssid;

  // eeprom 에서 ssid를 읽어옴.
  // 가장 첫 주소의 값은 ssid 문장의 길이를 나타냄.
  // 읽은 데이터를 String object로 리턴 함.
}

/*
 *  EEPROM에서 ssid를 읽어들이는 함수
 */
void write_ssid_to_eeprom( int address, String _ssid ) {

  for (int i = 0; i <= _ssid.length(); i++) {
    if (i == 0) {
      EEPROM.write(address++, _ssid.length());
    }
    else {
      EEPROM.write(address++, _ssid.charAt(i - 1));
    }
  }

  EEPROM.commit();

  // eeprom 에다가 ssid를 씀.
  // 가장 첫 주소의 값은 ssid 문장의 길이를 나타냄.
  // password의 주소 부분을 침범하지 않도록 ssid가 100자가 넘는지 확인해야 함..
  // password 주소 = 100번지 부터.. ssid는 0번지부터.. 즉 0~99로 100의 공간이 존재.
  // but 주소의 첫 바이트는 길이이므로 99자리가 남음.
  // 100 자리 이상일 경우에는 업데이트하지 않고 함수 종료
}

/*
 *  EEPROM에서 password를 읽어들이는 함수
 */
String read_password_from_eeprom( int firstAddress ) {
  String read_password = String();
  int ssid_length = int(EEPROM.read(firstAddress++));

  for (int forLen = 0; forLen < ssid_length; forLen++) {
    read_password += char(EEPROM.read(firstAddress++));
  }
  return read_password;
}

/*
 *  EEPROM에서 password를 읽어들이는 함수
 */
void write_password_to_eeprom(int address, String _password ) {

  for (int i = 0; i <= _password.length(); i++) {
    if (i == 0) {
      EEPROM.write(address++, _password.length());
    }
    else {
      EEPROM.write(address++, _password.charAt(i - 1));
    }
  }

  EEPROM.commit();
}

// 메인화면 Test data들을 출력해준다.
void handleRoot() {
  String rootText = FPSTR(HTML);
  rootText.replace("<titleContent>", "ESP8266 Demo");
  rootText.replace("<bodyContent>", String("<h1>Hello from Happy Hedgehog house !!</h1>")
                   + "<h1>안녕하세요. 해피 호구 하우스입니다!!</h1>"
                   + "<p>Temperature: " + temperature + ", Humidity: " + humidity + "</p>");
  server.send(200, "text/html;", rootText);
}

/*
 * setting 관련.. form 태그 이용. 변경하기 버튼 클릭시 리다이렉션 됨.
 * 리다이렉션시 POST메소드로 arg에 입력한 내용이 들어있음.
 * TOOD : 허용하지 않는 입력 처리하기.
 */
void handleSettingForm() {
  if (server.method() == HTTP_POST) {
    // 입력된 내용을 스트링으로 만듦
    String message = "아래와 같이 설정 되었습니다.<br/>";
    for ( uint8_t i = 0; i < server.args(); i++) {
      String _argName = server.argName(i);
      String _arg = server.arg(i);

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
    server.send(200, "text/html; charset=utf-8", message);

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

      // 이전 server 클래스에 등록한 handler를 지울 방법이 없으므로..
      // 인스턴스를 다시 만듦.
      server = ESP8266WebServer(WEB_PORT);
      openStation();
      startServer();
    } 
  } else {
    // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
    String formMessage = FPSTR(HTML_TEMPLATE);
    formMessage.replace("<titleContent>", "MyHappyHog Setting");
    formMessage.replace("<bodyContent>", "<form action=\"" + server.uri() + "\" method=\"POST\">"
                        + "ssid : <input type=\"text\" name=\"" + ARG_NAME_SSID + "\"/><br/>"
                        + "password : <input type=\"password\" name=\"" + ARG_NAME_PASSWORD + "\"/><br/>"
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
  WiFi.softAP( ssid.c_str(), password.c_str() );

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);

  // Root Url 과 not found 핸들러 등록
  server.on("/", handleSettingForm);
  server.onNotFound ( handleNotFound );
}

// Station 모드로 공유기를 이용하여 mdns 서버 열기
void openStation() {
  delay(1000);
  Serial.println("Configuring station mode...");
  Serial.println(ssid);
  Serial.println(password);
  WiFi.begin ( ssid.c_str(), password.c_str() );

  // Wait for connection
  // 연결되지 않으면 계속 연결 시도 함.
  while ( WiFi.waitForConnectResult() != WL_CONNECTED ) {
    delay(500);
    Serial.println ( "WiFi Not Connected.. and reconnect..." );
    WiFi.begin ( ssid.c_str(), password.c_str() );
  }

  Serial.println ( "" );
  Serial.print ( "Connected to " );
  Serial.println ( ssid );
  Serial.print ( "IP address: " );
  Serial.println ( WiFi.localIP() );
  Serial.println ( "" );

  // mdns 열기
  // 연결되지 않으면 계속 연결 시도 함.
  Serial.println ( "start MDNS" );
  while ( !MDNS.begin ( "esp8266" ) ) {
    delay(500);
    Serial.print ( "." );
  }
  Serial.println ( "esp8266 MDNS responder started" );

  // 서버의 url 주소 핸들링
  server.on ( "/", handleRoot );
  server.on ( "/setting", handleSettingForm );
  server.onNotFound ( handleNotFound );

  // http를 서비스에 등록한다.
  MDNS.addService("http", "tcp", WEB_PORT);
}

/*
 * 웹 서버를 시작한다.
 * 만약 begin 이후에도 서버가 close 상태라면
 * 연결이 될 때까지 계속 시도 함.
 */
void startServer() {
  server.begin();
  /*
  while ( server.status() == CLOSE ) {
    delay(500);
    Serial.print( "." );
    server.begin();
  }
  */
  Serial.println( "" );
  Serial.println("HTTP server started");
}

/*
 *  Serial을 연결하고 EEPROM의 설정을 로드함.
 *  EEPROM의 모드에 따라 AP 혹은 STATION 웹 서버를 엶.
 */
void setup() {
  Serial.begin(115200);
  Serial.println();

  loadConfigure();

  Serial.println(ssid.c_str());
  Serial.println(password.c_str());
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
