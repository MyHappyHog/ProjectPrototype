#include <EEPROM.h>

#define EEPROM_SIZE 512

#define FIRST_ADDRESS_OF_SSID 0
#define FIRST_ADDRESS_OF_PASSWORD 100

String ssid = "happyhog";
String password = "hog12345";

#define IS_FIRST_BOOT 511

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  EEPROM.begin(EEPROM_SIZE);
  
  EEPROM_CLEAR();

  // init ssid
  EEPROM.write( FIRST_ADDRESS_OF_SSID, ssid.length() );
  EEPROM_WRITE( FIRST_ADDRESS_OF_SSID + 1, ssid );

  // init password
  EEPROM.write( FIRST_ADDRESS_OF_PASSWORD, password.length() );
  EEPROM_WRITE( FIRST_ADDRESS_OF_PASSWORD + 1, password );

  // init isFirstBoot
  EEPROM.write( IS_FIRST_BOOT, 1 );

  EEPROM.commit();
}

void loop() {
  // check data
  byte ssid_length = EEPROM.read( FIRST_ADDRESS_OF_SSID );
  Serial.println( EEPROM_READ( FIRST_ADDRESS_OF_SSID + 1, ssid_length ) );

  byte password_length = EEPROM.read( FIRST_ADDRESS_OF_PASSWORD );
  Serial.println( EEPROM_READ( FIRST_ADDRESS_OF_PASSWORD + 1, password_length ) );

  Serial.println( EEPROM.read( IS_FIRST_BOOT ) );

  delay(1000);
}

void EEPROM_CLEAR() {
    for ( int i = 0 ; i < EEPROM_SIZE ; i++ )
      EEPROM.write(i, 0);
}

String EEPROM_READ(int firstAddress, int length){
  String readText = String();
  
  for(int forI = 0; forI < length; forI++){
    readText += char(EEPROM.read(firstAddress++));
  }
  return readText;
}

int EEPROM_WRITE(int address, String writeText) {
  
  for(int i = 0; i < writeText.length(); i++) {
    EEPROM.write(address++, writeText.charAt(i));
  }
  EEPROM.commit();
  return address;
}
