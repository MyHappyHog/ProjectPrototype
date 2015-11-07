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

#define DHTPIN1 5     
#define DHTPIN2 4     
#define DHTPIN3 2     

/* Measurement Range: 0-50'C*/
#define TEMP_MIN 0
#define TEMP_MAX 50

/* Measurement Range: 20-90%RH*/
#define HUMI_MIN 20
#define HUMI_MAX 90

#define DHTTYPE DHT11
#define NUM_OF_DHT 3


////////////// put your router name and password //////////////

//const char* ssid = "ROUTER_NAME";
//const char* password = "PASSWORD";

const char* ssid = "Johnny";
const char* password = "net12345";

// TCP server at port 80 will respond to HTTP requests
WiFiServer server(80);

// Initialize DHT sensor.
DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);
DHT dht3(DHTPIN3, DHTTYPE);

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
   
  /* Normalization Code be placed in here */

  int temperature[NUM_OF_DHT];
  int humidity[NUM_OF_DHT];
  char DHTDataText[NUM_OF_DHT][10];

  getDHTData(temperature, humidity);
     
  for (int i = 0; i < NUM_OF_DHT; i++) {
     snprintf(DHTDataText[i], sizeof(DHTDataText[i]), "%2d'C, %2d%", temperature[i], humidity[i]);
    }
  
  /* Web Server */
  
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  } // Do nothing if there is no client
  
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

    printDHTData(temperature, humidity);
    
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
      <p>local IP Address: %d.%d.%d.%d</p>\
      <p>data1: %s / data2: %s / data3: %s</p>\
    </body>\
 </html>", ip[0], ip[1], ip[2], ip[3], DHTDataText[0], DHTDataText[1], DHTDataText[2]);

    Serial.println("Sending 200");
  } // for 'index.html' request
  else
  {
    snprintf(htmlDoc, sizeof(htmlDoc), "HTTP/1.1 404 Not Found\r\n\r\n");
    Serial.println("Sending 404");
  } // for another page request
  
  client.print(htmlDoc); // send html data to client
  
  Serial.println("Done with client");
}

void getDHTData(int* temperature, int* humidity) {

  int temp[NUM_OF_DHT], humid[NUM_OF_DHT];
  
  temp[0] = (int)dht1.readTemperature();
  humid[0] = (int)dht1.readHumidity();
  
  temp[1] = (int)dht2.readTemperature();
  humid[1] = (int)dht2.readHumidity();
  
  temp[2] = (int)dht3.readTemperature();
  humid[2] = (int)dht3.readHumidity();
  
  for (int i = 0; i < NUM_OF_DHT; i++) {
    
    
    if (TEMP_MIN <= temp[i] && temp[i] <= TEMP_MAX) {
      temperature[i] = temp[i];
    }
    if(HUMI_MIN <= humid[i] && humid[i] <= HUMI_MAX) {
      humidity[i] = humid[i];
    }
    
  }
}

void printDHTData(int* temp, int* humid) {
  for(int i = 0; i < NUM_OF_DHT; i++){
    
    Serial.print("DHT No. ");
    Serial.print(i);
    Serial.print(", temp: ");
    Serial.print(temp[i]);
    Serial.print(", humidity: ");
    Serial.print(humid[i]);
    Serial.println();
  }
}
