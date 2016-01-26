// AP 모드로 Server 열기
void openSoftAP(String& ssid, String& password, bool hidden) {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.print("Configuring access point...");
#endif
  if ( password.equals("") || password.length() < 8 ) {
    password = "hog12345";
  }
  WiFi.softAP( ssid.c_str(), password.c_str(), 0, hidden );
#ifdef DEBUG_MODE
  WiFi.printDiag(Serial);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
#endif
}

// Station 모드로 공유기를 이용하여 mdns 서버 열기
void openStation(String& ssid, String& password) {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.println("Configuring station mode...");
#endif

  if (ssid.equals("")) {
    return ;
  }

  WiFi.begin ( ssid.c_str(), password.c_str() );

  // Wait for connection
  // 연결되지 않으면 계속 연결 시도 함.
  WiFi.waitForConnectResult();

#ifdef DEBUG_MODE
  WiFi.printDiag(Serial);
#endif

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
}

void openDualMode(String& mac, String& ssid, String& password) {
  openSoftAP(mac, password, 0);
  openStation(ssid, password);
}

void addHandlerToServer() {
  // 서버의 url 주소 핸들링

  // 모든 테이블을 보여줌.
  server->on ( "/", HTTP_GET, handleShowTable );
  
  server->on ( "/", HTTP_POST, handleShowData );
  server->on ( "/food", HTTP_GET, handlePutFood );

  server->on ( "/new", HTTP_GET, handleShowNewDataForm );
  server->on ( "/create", HTTP_POST, handleNew );

  server->on ( "/edit", HTTP_GET, handleShowEditDataForm );
  server->on ( "/update", HTTP_POST, handleUpdate );
  server->on ( "/update", HTTP_PUT, handleUpdate );
  
  server->on ( "/delete", HTTP_POST, handleDelete );

  server->on ( "/init", HTTP_GET, handleShowWifiForm );
  server->on ( "/init", HTTP_POST, handleWifiConfig);
  
  //  server->on ( "/state", HTTP_GET, /* */ );
  //  server->on ( "/state", HTTP_POST, /* */ );

  server->onNotFound ( handleNotFound );
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
