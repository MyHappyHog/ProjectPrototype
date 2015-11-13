
void SendSettingHTML(WiFiClient client) {
  
  char htmlDoc[450];
    
    // Assemble html document 
    snprintf(htmlDoc, sizeof(htmlDoc),
"<html>\
  <head>\
    <meta http-equiv='refresh' content='10'/>\
      <title>Happyhog Setting</title>\
      <style>\
        body { background-color: #364659; font-family: Arial, Helvetica, Sans-Serif; Color: #F2F2F2; }\
      </style>\
    </head>\
    <body>\
      <h1>To be implement</h1>\
    </body>\
 </html>");

    Serial.println("Sending 200");
    
    client.print(htmlDoc); // send html data to client
}

