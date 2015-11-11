// DHT Monitor

// Processor configuration for Arduino pro mini:
// Atmega328 (3.3v 8 Mhz)

#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DHT.h>

#define DHTPIN 5     // what pin we're connected to

// Uncomment whatever type you're using!
#define DHTTYPE DHT11   // DHT 11

// Initialize DHT sensor.
DHT dht(DHTPIN, DHTTYPE);

LiquidCrystal_I2C lcd(0x27,16,2);  // set the LCD address to 0x27 for a 16 chars and 2 line display


void setup() {
  // initialize the lcd 
  Serial.begin(115200);
  lcd.init();
  lcd.backlight();
  
  // begin the DHT
  dht.begin();

}

void loop() {
  
  delay(500);
  lcd.setCursor(0,0); // first box of first line
  lcd.print("Temp:");
  
  lcd.setCursor(7,0); // eighth box of first line
  lcd.print((int)dht.readTemperature());
  lcd.print("'C");
  
  lcd.setCursor(0,1);// first box of second line
  lcd.print("Humid:");
  
  lcd.setCursor(7,1); // eighth box of first line
  lcd.print((int)dht.readHumidity());
  lcd.print(" %");

}
