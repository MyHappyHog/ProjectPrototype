#include <EEPROM.h>

#define EEPROM_SIZE 512

String awesomeText = "Hello EEPROM!!";

int address = 129;
int lastTextAddress;

void setup() {
  // 시리얼 셋팅 115200 보드레이트 사용
  Serial.begin(115200);
  
  // 시리얼이 열렸는지 확인
  while(!Serial) {}
  
  // eeprom 셋팅. 
  // eeprom의 size를 초과한 값을 전달하면 최대값으로 설정됨.
  EEPROM.begin(EEPROM_SIZE);

  // eeprom의 data[address]에 awesomeText 씀.
  for(int i = 0; i < awesomeText.length(); i++) {
    EEPROM.write(address++, awesomeText.charAt(i));
  }
  
  // 끝 주소 assignment
  lastTextAddress = address;
  
  // write하고 commit을 해주어야 ROM에 저장 됨
  EEPROM.commit();

  // address 를 awesome text를 입력한 처음 위치로 이동
  address = 129;
}

void loop() {
  // eeprom의 address의 값을 읽어 옴.
  byte value = EEPROM.read(address++);

  // 출력
  Serial.print((char)value); // 캐릭터로 출력

  // awesome text를 모두 출력하면 newline으로 이동하여 계속 출력
  if(address == lastTextAddress) {
    address = 129;
    Serial.println();
  }

  delay(500);
}
