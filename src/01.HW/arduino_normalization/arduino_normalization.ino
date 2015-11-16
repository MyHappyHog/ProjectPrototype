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
#define NUM_OF_DATA 10    // number of nomalization data
#define TRIM_PERCENT 20   // percent of trimmed mean


////////////// put your router name and password //////////////

//const char* ssid = "ROUTER_NAME";
//const char* password = "PASSWORD";

const char* ssid = "nlp";
const char* password = "nlp12345";

char htmlDoc[1000];

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
  double temperature[NUM_OF_DATA] = {0, };
  double humidity[NUM_OF_DATA] = {0, };
  char DHTDataText[10];

 double temp = getTemData(temperature);
 double humid = getHumData(humidity);
     snprintf(DHTDataText, sizeof(DHTDataText), "%2d'C, %2d%",   temp, 
  humid);
//
  /* Web Server */
  
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  } // Do nothing if there is no client
  
  Serial.println("");
  Serial.println("New client");

  // Wait for data from client to become available
  int count = 0;
  while(client.connected() && !client.available()){
    delay(1);
    
    count+=1;
    if (count == 3000) {
      snprintf(htmlDoc, sizeof(htmlDoc), "HTTP/1.1 404 Not Found\r\n\r\n");
      Serial.println("Sending 404");
      client.print(htmlDoc); // send html data to client
    } // close connect if no response until 3 sec
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

  if (req == "/")
  {
    IPAddress ip = WiFi.localIP();
    String ipStr = String(ip[0]) + '.' + String(ip[1]) + '.' + String(ip[2]) + '.' + String(ip[3]);

    printDHTData(temp, humid);
    
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
  else if (req == "favicon.ico") {return;} // do nothing
  else {
    snprintf(htmlDoc, sizeof(htmlDoc), "HTTP/1.1 404 Not Found\r\n\r\n");
    Serial.println("Sending 404");
  } // for another page request
  
  client.print(htmlDoc); // send html data to client
  
  Serial.println("Done with client");
}

double getTemData(double temperature[]) {

  double temp[NUM_OF_DATA];

  for( int i = 0; i < (NUM_OF_DATA/3); i = i + 3){
  
  temp[i] = (double)dht1.readTemperature();
  temp[i + 1] = (double)dht2.readTemperature();
  temp[i + 2] = (double)dht3.readTemperature();
  delay(1000);

  if (TEMP_MIN <= temp[i] && temp[i] <= TEMP_MAX) {
      temperature[i] = temp[i];
      temperature[i+1] = temp[i+1];
      temperature[i+2] = temp[i+2];
    }
  }
  findTrimmed(temperature,TRIM_PERCENT);
  return zScore(temperature);
}


double getHumData(double humidity[]) {

  double humid[NUM_OF_DATA];

  for( int i = 0; i < (NUM_OF_DATA/3); i = i + 3){
  
  humid[i] = (double)dht1.readHumidity();
  humid[i + 1] = (double)dht2.readHumidity();
  humid[i + 2] = (double)dht3.readHumidity();
  delay(1000);
    if(HUMI_MIN <= humid[i] && humid[i] <= HUMI_MAX) {
      humidity[i] = humid[i];
      humidity[i+1] = humid[i+1];
      humidity[i+2] = humid[i+2];
    }
  }
  findTrimmed(humidity,TRIM_PERCENT);
  return zScore(humidity);
}

double findMean(double arr[]){

  double addAll = 0, meanResult = 0;
  for (int i = 0; i < NUM_OF_DATA; i++){
    addAll += arr[i];
  }
  meanResult = addAll / double(NUM_OF_DATA);
  return meanResult;
}

double findDeviation(double arr[]){
  double total = 0, devResult = 0, mean = findMean(arr);
  
  for (int i = 0; i < NUM_OF_DATA; i++){
    total += (arr[i] - mean) * (arr[i] - mean);
  }
  total = total / double(NUM_OF_DATA);
  
  total = sqrt((double)total);
  devResult += total;
 
  return devResult;
  
}

double findMedian(double arr[]){
  for (int i = 0; i < NUM_OF_DATA; i++){
    for (int j = i+1; j < NUM_OF_DATA - i; j++){
      if (arr[i] > arr[j]){
        double temp;
        temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }
  }
  int middle = NUM_OF_DATA / 2;
  if (NUM_OF_DATA % 2 ){      // Ȧ�� 
    return (arr[middle]);
  }
  else{         // ¦��
    return (arr[middle - 1] + arr[middle]) / 2.0;
  }
}

double findTrimmed(double arr[], double percent){
  double median = findMedian(arr);
  double trim = NUM_OF_DATA * (percent / 100.0);
  for (int i = 0; i < trim; i++){
    arr[i] = median;
    arr[(NUM_OF_DATA - i) - 1] = median;
  }
  return findMean(arr);
}

double zScore(double arr[]){
  double mean = findMean(arr), dev = findDeviation(arr);
  for (int i = 0; i < NUM_OF_DATA; i++){
    double zNum = (mean - arr[i]) / dev;
    if (zNum > 1 || zNum < -1){
      arr[i] = mean;
    }
  }

  return findMean(arr);
}
void printDHTData(double temp, double humid) {

    Serial.print(", temp: ");
    Serial.print(temp);
    Serial.print(", humidity: ");
    Serial.print(humid);
    Serial.println();
}
