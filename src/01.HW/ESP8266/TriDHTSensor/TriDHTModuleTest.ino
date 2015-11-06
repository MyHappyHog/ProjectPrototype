#include <DHT.h>

#define DHTPIN1 5     
#define DHTPIN2 4     
#define DHTPIN3 2     

#define DHTTYPE DHT11


DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);
DHT dht3(DHTPIN3, DHTTYPE);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly:

//  
//  Serial.print(dht1.readTemperature());
//  Serial.print("'C ");
//  Serial.print(dht1.readHumidity());
//  Serial.print("%  /  ");
//  
//  Serial.print(dht2.readTemperature());
//  Serial.print("'C ");
//  Serial.print(dht2.readHumidity());
//  Serial.print("%  /  ");
//  
//  
//  Serial.print(dht3.readTemperature());
//  Serial.print("'C ");
//  Serial.print(dht3.readHumidity());
//  Serial.println("%    ");
//
//  Serial.println();
 

  char str[100];
  snprintf(str, sizeof(str), "1: %2d'C, %2d % / 2: %2d'C, %2d % / 3: %2d'C, %2d %",
  (int)dht1.readTemperature(), (int)dht1.readHumidity(),
  (int)dht2.readTemperature(), (int)dht2.readHumidity(),
  (int)dht3.readTemperature(), (int)dht3.readHumidity());
  for (int i = 0; i < 44; i++) {
    Serial.print(str[i]);
  }Serial.println();
  delay(1000);
}
