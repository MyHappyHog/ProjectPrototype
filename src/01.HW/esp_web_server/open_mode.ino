// AP 모드로 Server 열기
void openSoftAP() {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.print("Configuring access point...");
#endif
  WiFi.softAP( ssid.c_str(), password.c_str() );
#ifdef DEBUG_MODE
  WiFi.printDiag(Serial);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
#endif

  // Root Url 과 not found 핸들러 등록
  server->on("/", HTTP_GET, handleShowSetting);
  server->on("/", HTTP_POST, handleInitConfig);
  server->onNotFound ( handleNotFound );
}

// Station 모드로 공유기를 이용하여 mdns 서버 열기
void openStation() {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.println("Configuring station mode...");
#endif
  WiFi.begin ( ssid.c_str(), password.c_str() );
#ifdef DEBUG_MODE
  WiFi.printDiag(Serial);
#endif
  // Wait for connection
  // 연결되지 않으면 계속 연결 시도 함.
  WiFi.waitForConnectResult();

#ifdef DEBUG_MODE
  Serial.println ( "" );
  Serial.print ( "Connected to " );
  Serial.println ( ssid.c_str() );
  Serial.println ( password.c_str() );
  Serial.print ( "IP address: " );
  Serial.println ( WiFi.localIP() );
  Serial.println ( "" );


  Serial.println ( "start MDNS" );
#endif

  // mdns 열기
  // 연결되지 않으면 계속 연결 시도 함.
  while ( !MDNS.begin ( "esp8266" ) ) {
    delay(500);
#ifdef DEBUG_MODE
    Serial.print ( "." );
#endif
  }

#ifdef DEBUG_MODE
  Serial.println ( "esp8266 MDNS responder started" );
#endif
  // 서버의 url 주소 핸들링
  server->on ( "/", HTTP_GET, handleRoot );
  server->on ( "/food", HTTP_GET, handlePutFood );

//  server->on ( "/show", HTTP_GET, /*handleSettingForm*/ );
//  server->on ( "/show_table", HTTP_GET, /* */ );
  server->on ( "/new", HTTP_GET, handleShowSettingPut );

//  server->on ( "/create", HTTP_POST, /* */ );
  server->on ( "/edit", HTTP_POST, handlePutIn);
//  server->on ( "/delete", HTTP_DELETE, /* */ );

//  server->on ( "/state", HTTP_GET, /* */ );
//  server->on ( "/state", HTTP_POST, /* */ );
  
  server->onNotFound ( handleNotFound );

  // http를 서비스에 등록한다.
  MDNS.addService("http", "tcp", WEB_PORT);
}

/*
   웹 서버를 시작한다.
   만약 begin 이후에도 서버가 close 상태라면
   연결이 될 때까지 계속 시도 함.
*/
void startServer() {
  server->begin();
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.println("HTTP server started");
#endif
}
