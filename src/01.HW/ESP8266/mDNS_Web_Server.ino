/*
  ESP8266 mDNS responder 

  This is an example of an HTTP server that is accessible
  via http://hhh.local URL thanks to mDNS responder.

  Instructions:
  - Update WiFi SSID and password as necessary.
  - Flash the sketch to the ESP8266 board
  - Install host software:
    - For Linux, install Avahi (http://avahi.org/).
    - For Windows, install Bonjour (http://www.apple.com/support/bonjour/).
    - For Mac OSX and iOS support is built in through Bonjour already.
  - Point your browser to http://hhh.local, you should see a response.

 */


#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiClient.h>
#include <DHT.h>

#define DHTPIN 5     // what pin we're connected to
#define DHTTYPE DHT11

////////////// put your router name and password //////////////

const char* ssid = "ROUTER_NAME";
const char* password = "PASSWORD";

// TCP server at port 80 will respond to HTTP requests
WiFiServer server(80);

// Initialize DHT sensor.
DHT dht(DHTPIN, DHTTYPE);

////////////// here is a setup code //////////////

void setup(void)
{  
  Serial.begin(115200);
  
  // Connect to WiFi network
  WiFi.begin(ssid, password);
  Serial.println("");  
  
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  // Set up mDNS responder:
  // - first argument is the domain name, in this example
  //   the fully-qualified domain name is "esp8266.local"
  // - second argument is the IP address to advertise
  //   we send our IP address on the WiFi network
  if (!MDNS.begin("hhh")) {
    Serial.println("Error setting up MDNS responder!");
    while(1) { 
      delay(1000);
    }
  }
  Serial.println("mDNS responder started");
  
  // Start TCP (HTTP) server
  server.begin();
  Serial.println("TCP server started");
  
  // Add service to MDNS-SD
  MDNS.addService("http", "tcp", 80);
}

////////////// here is a loop code //////////////

void loop(void)
{
  
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  }
  Serial.println("");
  Serial.println("New client");

  // Wait for data from client to become available
  while(client.connected() && !client.available()){
    delay(1);
  }
  
  // Read the first line of HTTP request
  String req = client.readStringUntil('\r');
  
  // First line of HTTP request looks like "GET /path HTTP/1.1"
  // Retrieve the "/path" part by finding the spaces
  int addr_start = req.indexOf(' ');
  int addr_end = req.indexOf(' ', addr_start + 1);
  if (addr_start == -1 || addr_end == -1) {
    Serial.print("Invalid request: ");
    Serial.println(req);
    return;
  }
  req = req.substring(addr_start + 1, addr_end);
  Serial.print("Request: ");
  Serial.println(req);
  client.flush();
  
  //String s; // yoon // remove
  char htmlDoc[1000];

  if (req == "/")
  {
    IPAddress ip = WiFi.localIP();
    String ipStr = String(ip[0]) + '.' + String(ip[1]) + '.' + String(ip[2]) + '.' + String(ip[3]);
    char temperature[5];
    char humidity[4];
    
    snprintf(temperature, sizeof(temperature), "%2d'C", (int)dht.readTemperature());
    snprintf(humidity, sizeof(humidity), "%2d%", (int)dht.readHumidity());
    
    // write html document 
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
      <p>Temperature: %s, Humidity: %s</p>\
    </body>\
 </html>", temperature, humidity);


    Serial.println("Sending 200");
  }
  else
  {
    snprintf(htmlDoc, sizeof(htmlDoc), "HTTP/1.1 404 Not Found\r\n\r\n");
    Serial.println("Sending 404");
  }
  client.print(htmlDoc);
  
  Serial.println("Done with client");
}

