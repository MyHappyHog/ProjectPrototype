
void SendInfoHTML(WiFiClient client, char* data1, char* data2, char*data3) {
  
  char htmlDoc[450];
  IPAddress ip = WiFi.localIP();
    
    // Assemble html document 
    snprintf(htmlDoc, sizeof(htmlDoc),
"<html>\
  <head>\
    <meta http-equiv='refresh' content='10'/>\
      <title>ESP8266 Demo</title>\
      <style>\
        body { background-color: #364659; font-family: Arial, Helvetica, Sans-Serif; Color: #F2F2F2; }\
      </style>\
    </head>\
    <body>\
      <h1>Hello from Happy Hedgehog House !!</h1>\
      <p>local IP Address: %d.%d.%d.%d</p>\
      <p>data1: %s / data2: %s / data3: %s</p>\
    </body>\
 </html>", ip[0], ip[1], ip[2], ip[3], data1, data2, data3);

    Serial.println("Sending 200");
    
    client.print(htmlDoc); // send html data to client
}

