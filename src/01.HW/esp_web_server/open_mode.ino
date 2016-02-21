// AP 모드로 Server 열기
void openSoftAP(Wifi* wifiInfo, bool hidden) {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.print("Configuring access point...");
#endif
  String ssid = wifiInfo->getSSID();
  if (!ssid.equals("")) {
    return ;
  }

  String password = wifiInfo->getPassword();
  if ( password.equals("") || password.length() < 8 ) {
    password = "hog12345";
  }

  ssid = WiFi.softAPmacAddress();
  ssid.replace(":", "");
  WiFi.softAP( ssid.c_str(), password.c_str(), 0, hidden );

#ifdef DEBUG_MODE
  Serial.println(ssid);
  Serial.println(password);

  WiFi.printDiag(Serial);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
#endif
}

// Station 모드로 wifi에 접속
void openStation(Wifi* wifiInfo) {
#ifdef DEBUG_MODE
  Serial.println( "" );
  Serial.println("Configuring station mode...");
#endif

  String ssid = wifiInfo->getSSID();
  String password = wifiInfo->getPassword();

  if (ssid.equals("")) {
    return ;
  }

#ifdef DEBUG_MODE
  Serial.println(ssid);
  Serial.println(password);
#endif

  WiFi.begin ( ssid.c_str(), password.c_str() );
  //WiFi.begin ( "joh", "jongho123" );

  // Wait for connection
  // 연결되지 않으면 계속 연결 시도 함.
  while ( WiFi.waitForConnectResult() != WL_CONNECTED ) {
    delay(500);
    Serial.print(".");
    WiFi.begin ( ssid.c_str(), password.c_str() );
  };

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
#endif
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
