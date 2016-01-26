#define ARG_NAME_SSID "ssid"
#define ARG_NAME_PASSWORD "password"
#define ARG_NAME_RELAY_MAC "relayMac"

#define ARG_NAME_ANIMAL_NAME "animalName"
#define ARG_NAME_MAX_TEMPERATURE "maxTemperature"
#define ARG_NAME_MIN_TEMPERATURE "minTemperature"
#define ARG_NAME_MAX_HUMIDITY "maxHumidity"
#define ARG_NAME_MIN_HUMIDITY "minHumidity"
#define ARG_NAME_MAX_ILLUMINATION "maxillumination"
#define ARG_NAME_MIN_ILLUMINATION "minillumination"
#define ARG_NAME_TEMP_RELAY "tempRelay"
#define ARG_NAME_HUMID_RELAY "humidRelay"
#define ARG_NAME_ILLUM_RELAY "illumRelay"

#define DEFAULT_MAX_TEMPERATURE 30
#define DEFAULT_MIN_TEMPERATURE 20
#define DEFAULT_MAX_HUMIDITY 50
#define DEFAULT_MIN_HUMIDITY 30
#define DEFAULT_MAX_ILLUMINATION 80
#define DEFAULT_MIN_ILLUMINATION 50
#define DEFAULT_TEMP_RELAY 1
#define DEFAULT_HUMID_RELAY 2
#define DEFAULT_ILLUM_RELAY 3

String animalName = "";
int maxTemperature = DEFAULT_MAX_TEMPERATURE;
int minTemperature = DEFAULT_MIN_TEMPERATURE;
int maxHumidity = DEFAULT_MAX_HUMIDITY;
int minHumidity = DEFAULT_MIN_HUMIDITY;
int maxillumination = DEFAULT_MAX_ILLUMINATION;
int minillumination = DEFAULT_MIN_ILLUMINATION;
int temperatureRelay = DEFAULT_TEMP_RELAY;
int humidityRelay = DEFAULT_HUMID_RELAY;
int illuminationRelay = DEFAULT_ILLUM_RELAY;
String ip;
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
  "<form action=\"/init\" method=\"POST\">\
  relay Mac : <input type=\"text\" name=\"<macContent>\" value=\"<relayValueContent>\"/><br/>\
  ssid : <input type=\"text\" name=\"<ssidContent>\"/><br/>\
  password : <input type=\"password\" name=\"<passwordContent>\"/><br/>\
  <input type=\"submit\" value=\"설정하기\"/>\
</form>"

#define DATA_FORM_TEMPLATE \
  "<form action=\"<urlContent>\" method=\"POST\">\
  동물 이름 : <input type=\"text\" name=\"<animalContent>\" required /><br/>\
  최고 온도 : <input type=\"text\" name=\"<maxTempContent>\" /><br/>\
  최저 온도 : <input type=\"text\" name=\"<minTempContent>\" /><br/>\
  최고 습도 : <input type=\"text\" name=\"<maxHumidContent>\" /><br/>\
  최저 습도 : <input type=\"text\" name=\"<minHumidContent>\" /><br/>\
  최고 조도 : <input type=\"text\" name=\"<maxillumContent>\" /><br/>\
  최저 조도 : <input type=\"text\" name=\"<minillumContent>\" /><br/>\
  온도 릴레이 : <input type=\"text\" name=\"<tempRelayContent>\" /><br/>\
  습도 릴레이 : <input type=\"text\" name=\"<humidRelayContent>\" /><br/>\
  조도 릴레이 : <input type=\"text\" name=\"<illumRelayContent>\" /><br/>\
  <input type=\"submit\" value=\"설정하기\"/>\
  <hiddenContent>\
</form>"

const char HTML[] PROGMEM = HTML_TEMPLATE;
const char WIFI_FORM[] PROGMEM = WIFI_FORM_TEMPLATE;
const char DATA_FORM[] PROGMEM = DATA_FORM_TEMPLATE;

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

// 메인화면을 출력해준다.
void handleShowData() {
  String rootText = FPSTR(HTML);
  rootText.replace("<titleContent>", "ESP8266 Demo");
  rootText.replace("<bodyContent>", String("<h1>Hello from Happy Hedgehog house !!</h1>")
                   + "<h1>안녕하세요. 해피 호구 하우스입니다!!</h1>"
                   + "<p>Temperature: " + temp + ", Humidity: " + humid + "</p>");
  server->send(200, "text/html;", rootText);
}

void handleShowTable() {
  String message = "show the tables";

  message += "<br/>";
  message += String("ip : ") + WiFi.localIP().toString() + ", 동물 이름 : " + animalName + "<br/>";

  server->send(200, "text/html; charset=utf-8", message);
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
void handleWifiConfig() {
  // @@@@@@@@@@@ make it
  // 12345(라우트) 포트가 열려있는지 확인하는 기능.
  //

  // esp를 처음 실행시켰을 경우에는
  // 입력한 ssid와 password 를 가진 공유기로 접속하여
  // mdns 서버를 실행.

  server->send(200);

  if (availableEditWifi == true) {
    // form 으로 전달된 데이터 중에서 아규먼트 이름이 ssid나 password 인 아규먼트를
    // ssid 와 password 로 assign 하고 eeprom을 업데이트.(write)
    ssid = server->arg(ARG_NAME_SSID);
    write_ssid_to_eeprom( FIRST_ADDRESS_OF_SSID, ssid );
    password = server->arg(ARG_NAME_PASSWORD);
    write_password_to_eeprom( FIRST_ADDRESS_OF_PASSWORD, password );

    // relay 접속

    // relay 세팅

    // 현재 WiFi 연결을 끊음.
    WiFi.disconnect(true);

    // 변경된 wifi 접속.
    openStation(ssid, password);
    startServer();

    // 메인 라우트가 있는지 확인
    // 있으면 자신의 데이터 전달

    ip = WiFi.localIP().toString();

    // 현재 ip 정보 수정
    availableEditWifi = false;
  }

  // make
  // 값 세팅 부분
}

// Wifi form을 반환
void handleShowWifiForm() {
  // 현재 주소로 리다이렉션을 위해 form의 action attribute에 현재 url을 넣어 줌.
  String formMessage = FPSTR(HTML);
  formMessage.replace("<titleContent>", "MyHappyHog Init");
  formMessage.replace("<bodyContent>", FPSTR(WIFI_FORM));
  formMessage.replace("<macContent>", ARG_NAME_RELAY_MAC);
  formMessage.replace("<relayValueContent>", relay_mac);
  formMessage.replace("<ssidContent>", ARG_NAME_SSID);
  formMessage.replace("<passwordContent>", ARG_NAME_PASSWORD);

  server->send(200, "text/html", formMessage);
}

// Data 생성하는 Setting Form을 반환
void handleShowNewDataForm() {
  String formMessage = FPSTR(HTML);
  formMessage.replace("<titleContent>", "MyHappyHog new Data");
  formMessage.replace("<bodyContent>", FPSTR(DATA_FORM));
  formMessage.replace("<urlContent>", "/create");
  formMessage.replace("<animalContent>", ARG_NAME_ANIMAL_NAME);
  formMessage.replace("<maxTempContent>", ARG_NAME_MAX_TEMPERATURE);
  formMessage.replace("<minTempContent>", ARG_NAME_MIN_TEMPERATURE);
  formMessage.replace("<maxHumidContent>", ARG_NAME_MAX_HUMIDITY);
  formMessage.replace("<minHumidContent>", ARG_NAME_MIN_HUMIDITY);
  formMessage.replace("<maxillumContent>", ARG_NAME_MAX_ILLUMINATION);
  formMessage.replace("<minillumContent>", ARG_NAME_MIN_ILLUMINATION);
  formMessage.replace("<tempRelayContent>", ARG_NAME_TEMP_RELAY);
  formMessage.replace("<humidRelayContent>", ARG_NAME_HUMID_RELAY);
  formMessage.replace("<illumRelayContent>", ARG_NAME_ILLUM_RELAY);
  formMessage.replace("<hiddenContent>", "");

  server->send(200, "text/html", formMessage);
}

// Data 변경하는 Setting Form을 반환
void handleShowEditDataForm() {
  String formMessage = FPSTR(HTML);
  formMessage.replace("<titleContent>", "MyHappyHog new Data");
  formMessage.replace("<bodyContent>", FPSTR(DATA_FORM));
  formMessage.replace("<urlContent>", "/update");
  formMessage.replace("<animalContent>", String("") + ARG_NAME_ANIMAL_NAME + "\" value = \"" + animalName);
  formMessage.replace("<maxTempContent>", String("") + ARG_NAME_MAX_TEMPERATURE + "\" value = \"" + maxTemperature);
  formMessage.replace("<minTempContent>", String("") + ARG_NAME_MIN_TEMPERATURE + "\" value = \"" + minTemperature);
  formMessage.replace("<maxHumidContent>", String("") + ARG_NAME_MAX_HUMIDITY + "\" value = \"" + maxHumidity);
  formMessage.replace("<minHumidContent>", String("") + ARG_NAME_MIN_HUMIDITY + "\" value = \"" + minHumidity);
  formMessage.replace("<maxillumContent>", String("") + ARG_NAME_MAX_ILLUMINATION + "\" value = \"" + maxillumination);
  formMessage.replace("<minillumContent>", String("") + ARG_NAME_MIN_ILLUMINATION + "\" value = \"" + minillumination);
  formMessage.replace("<tempRelayContent>", String("") + ARG_NAME_TEMP_RELAY + "\" value = \"" + temperatureRelay);
  formMessage.replace("<humidRelayContent>", String("") + ARG_NAME_HUMID_RELAY + "\" value = \"" + humidityRelay);
  formMessage.replace("<illumRelayContent>", String("") + ARG_NAME_ILLUM_RELAY + "\" value = \"" + illuminationRelay);
  formMessage.replace("<hiddenContent>", "<input type=\"hidden\" name=\"_method\" value=\"put\"/>");

  server->send(200, "text/html", formMessage);
}

void handleNew() {

  // TODO
  // 동물 테이블에서 현재 이름이 없는 테이블이 있는지 확인하는 코드 추가하기
  // 없으면 새로 만들 수 없음.

  // 구조체로 변경해야함.
  String nAnimalName = server->arg(ARG_NAME_ANIMAL_NAME);
  String nMaxTemperature = server->arg(ARG_NAME_MAX_TEMPERATURE);
  String nMinTemperature = server->arg(ARG_NAME_MIN_TEMPERATURE);
  String nMaxHumidity = server->arg(ARG_NAME_MAX_HUMIDITY);
  String nMinHumidity = server->arg(ARG_NAME_MIN_HUMIDITY);
  String nMaxillumination = server->arg(ARG_NAME_MAX_ILLUMINATION);
  String nMinillumination = server->arg(ARG_NAME_MIN_ILLUMINATION);
  String nTemperatureRelay = server->arg(ARG_NAME_TEMP_RELAY);
  String nHumidityRelay = server->arg(ARG_NAME_HUMID_RELAY);
  String nilluminationRelay = server->arg(ARG_NAME_ILLUM_RELAY);

  // white space 제거
  nAnimalName.trim();
  nMaxTemperature.trim();
  nMinTemperature.trim();
  nMaxHumidity.trim();
  nMinHumidity.trim();
  nMaxillumination.trim();
  nMinillumination.trim();
  nTemperatureRelay.trim();
  nHumidityRelay.trim();
  nilluminationRelay.trim();

  // 빈 곳에는 초기값 설정
  if (nMaxTemperature.equals("")) nMaxTemperature += DEFAULT_MAX_TEMPERATURE;
  if (nMinTemperature.equals("")) nMinTemperature += DEFAULT_MIN_TEMPERATURE;
  if (nMaxHumidity.equals("")) nMaxHumidity += DEFAULT_MAX_HUMIDITY;
  if (nMinHumidity.equals("")) nMinHumidity += DEFAULT_MIN_HUMIDITY;
  if (nMaxillumination.equals("")) nMaxillumination += DEFAULT_MAX_ILLUMINATION;
  if (nMinillumination.equals("")) nMinillumination += DEFAULT_MIN_ILLUMINATION;

  if (nTemperatureRelay.equals("")) nTemperatureRelay += DEFAULT_TEMP_RELAY;
  if (nHumidityRelay.equals("")) nHumidityRelay += DEFAULT_HUMID_RELAY;
  if (nilluminationRelay.equals("")) nilluminationRelay += DEFAULT_ILLUM_RELAY;

  // 예외 처리
  // - 동물 이름 입력안했을 때
  // - 최고 온, 습, 조도가 최저의 온, 습, 조도보다 낮거나 같을 때
  // TODO 측정 가능한 최대 최소 온습조도 밖의 값 예외처리
  if (nAnimalName.equals("")) {
    server->send(200, "text/html; charset=utf-8", "동물 이름이 입력되지 않았습니다.");
    return ;
  }
  if (nMaxTemperature.toInt() <= nMinTemperature.toInt()) {
    server->send(200, "text/html; charset=utf-8", "최고 온도가 최저 온도보다 높아야 합니다.");
    return ;
  }
  if (nMaxHumidity.toInt() <= nMinHumidity.toInt()) {
    server->send(200, "text/html; charset=utf-8", "최고 습도가 최저 습도보다 높아야 합니다.");
    return ;
  }
  if (nMaxillumination.toInt() <= nMinillumination.toInt()) {
    server->send(200, "text/html; charset=utf-8", "최고 조도가 최저 조도보다 높아야 합니다.");
    return ;
  }

  animalName = nAnimalName;
  maxTemperature = nMaxTemperature.toInt();
  minTemperature = nMinTemperature.toInt();
  maxHumidity = nMaxHumidity.toInt();
  minHumidity = nMinHumidity.toInt();
  maxillumination = nMaxillumination.toInt();
  minillumination = nMinillumination.toInt();

  temperatureRelay = nTemperatureRelay.toInt();
  humidityRelay = nHumidityRelay.toInt();
  illuminationRelay = nilluminationRelay.toInt();

  server->send(200, "text/html; charset=utf-8", "설정 되었습니다.");
}

void handleUpdate() {
  if ( server->arg("_method").equals("put") ) {
    server->send(200, "text/html", "update it");
  } else {
    handleNotFound();
  }
}

void handleDelete() {
  if ( server->arg("_method").equals("delete") ) {
    server->send(200, "text/html", "delete it");
  } else {
    handleNotFound();
  }
}
