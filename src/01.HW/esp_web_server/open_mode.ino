// AP 모드로 Server 열기
void openSoftAP() {
  Serial.println( "" );
  Serial.print("Configuring access point...");
  WiFi.softAP( ssid.c_str(), password.c_str() );
  WiFi.printDiag(Serial);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);

  // Root Url 과 not found 핸들러 등록
  server->on("/", handleSettingForm);
  server->onNotFound ( handleNotFound );
}

// Station 모드로 공유기를 이용하여 mdns 서버 열기
void openStation() {
  Serial.println( "" );
  Serial.println("Configuring station mode...");
  WiFi.begin ( ssid.c_str(), password.c_str() );
  WiFi.printDiag(Serial);
  // Wait for connection
  // 연결되지 않으면 계속 연결 시도 함.
  WiFi.waitForConnectResult();

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
  server->on ( "/", handleRoot );
  server->on ( "/setting", handleSettingForm );
  server->onNotFound ( handleNotFound );

  // http를 서비스에 등록한다.
  MDNS.addService("http", "tcp", WEB_PORT);
}

/*
 * 웹 서버를 시작한다.
 * 만약 begin 이후에도 서버가 close 상태라면
 * 연결이 될 때까지 계속 시도 함.
 */
void startServer() {
  server->begin();

  Serial.println( "" );
  Serial.println("HTTP server started");
}
