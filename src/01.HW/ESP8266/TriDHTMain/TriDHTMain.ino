/*
  TriDHTMain
  
  This is an HTTP server that shows Information of
  Temperature and Huumidiry information From DHT11 Sensors
  via http://hhh.local/ URL thanks to mDNS responder.
  
 */
 
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiClient.h>
#include <DHT.h>

#define DHTPIN1 5     
#define DHTPIN2 4     
#define DHTPIN3 2     

/* DHT Configurations */
#define DHTTYPE DHT11
#define NUM_OF_DHT 3

/* Case of html service */
#define NOTFOUND    0
#define INFO        1  
#define SETTING     2

// put your router name and password 

//const char* ssid = "ROUTER_NAME";
//const char* password = "PASSWORD";

// TCP server at port 80 will respond to HTTP requests
WiFiServer server(80);

// Initialize DHT sensor.
DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);
DHT dht3(DHTPIN3, DHTTYPE);

//--------------- here is a setup code ---------------//

void setup(void)
{  
  Serial.begin(115200);
//  
//  WiFi.mode(WIFI_AP_STA);
//  WiFi.softAP("esp", "net12345");
  
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

//--------------- here is a loop code ---------------//

void loop(void)
{
  /***** Get and Normalize DHT Values *****/
   
  /* Normalization Code be placed in here */
  
  int temperature[NUM_OF_DHT];
  int humidity[NUM_OF_DHT];
  char DHTDataText[NUM_OF_DHT][10];
  
  getDHTData(temperature, humidity);
     
  for (int i = 0; i < NUM_OF_DHT; i++) {
     snprintf(DHTDataText[i], sizeof(DHTDataText[i]), \
     "%2d'C, %2d%", temperature[i], humidity[i]);
  }
  
  /***** Check client and Get request *****/
  
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  } // Do nothing if there is no client
  
  Serial.println("");
  Serial.println("New client");

  // Wait for data from client to become available
  int count = 0;
  while(client.connected() && !client.available()) {
    delay(1);
    if (count++ == 10*1000) {
      // Close the current connection if there is
      // no response from client until 10 sec. 
      return;
    } 
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

  /***** Decode request and Decide what to send *****/
  
  /* Authentication Code be placed in here */
  int todo;
  if (req == "/info") {
    todo = INFO;
  }
  else if (req == "/setting") {
    todo = SETTING;
  }
  else {
    todo = NOTFOUND;
  }

  /***** Send html data to client *****/
  
  switch (todo) {
    
  case INFO: // html service for DHT information
    SendInfoHTML(client, DHTDataText[0], DHTDataText[1], DHTDataText[2]);
    break;
    
  case SETTING: // html service for modify configurations
    SendSettingHTML(client); // to be implement 
    break;
  
  case NOTFOUND:
  default:
    Send404NotFound(client);
  }
  
  Serial.println("Done with client");

  /***** Print data to Serial *****/
  Serial.print("Local IP: ");
  Serial.println(WiFi.localIP());
  
  printDHTData(temperature, humidity);
}


