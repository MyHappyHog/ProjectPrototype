#include <EEPROM.h> // include header for use EEPROM

#define _1K 1024

int address;

void setup() {
  
  Serial.begin(9600);
  address = 0;
  
}

void loop() {
  
  Serial.println();
  
  Serial.print("First 8 byte word: ");
  EEPROM_PRINT(0,8);

  Serial.println();
  
  Serial.print("Second 8 byte word: ");
  EEPROM_PRINT(8,8);

  Serial.println();
  
  Serial.print("All of 16 byte: ");
  EEPROM_PRINTALL(0,16);

  Serial.println();
  
  delay(5000);
}

void EEPROM_PRINT(int addr, int len) {
  
  for (int i = addr; i < addr+len; i++) {
    byte value;
    
    if ((value=EEPROM.read(i)) == 0) 
      return;
    
    Serial.print((char)value);
  }
}
void EEPROM_PRINTALL(int addr, int len) {
  
  for (int i = addr; i < addr+len; i++) 
    Serial.print((char)EEPROM.read(i));
  
}
