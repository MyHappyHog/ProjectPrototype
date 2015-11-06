#include <EEPROM.h> // include header for use EEPROM

int address = 0;

void setup() {
  
  char text[8];
  
  delay(1000);
  Serial.begin(9600);
  
  Serial.println("EEPROM Write Test");

  EEPROM_CLEAR(); // set all EEPROM bytes to 0

  snprintf(text, sizeof(text), "hello");
  EEPROM_WRITE(text, sizeof(text));
  
  snprintf(text, sizeof(text), "world");
  EEPROM_WRITE(text, sizeof(text));
  
  Serial.println("EEPROM Write Successfully done !!");
  
}

void loop() {
  delay(1000);
  
}

void EEPROM_CLEAR() {
    for ( int i = 0 ; i < EEPROM.length() ; i++ )
    EEPROM.write(i, 0);
}

void EEPROM_WRITE(char* text, int len) {
  
  for (int i = 0; i < len; i++) 
    EEPROM.write(address++, text[i]); // set text to EEPROM bytes
}



