void Send404NotFound(WiFiClient client) {

  char htmlDoc[30];
  snprintf(htmlDoc, sizeof(htmlDoc), "HTTP/1.1 404 Not Found\r\n\r\n");
  
  Serial.println("Sending 404");
  
  client.print(htmlDoc); // send html data to client
}

