/*
 *  EEPROM에서 ssid를 읽어들이는 함수
 */
String read_ssid_from_eeprom( int firstAddress ) {
  String read_ssid = String();
  int ssid_length = int(EEPROM.read(firstAddress++));

  for (int forLen = 0; forLen < ssid_length; forLen++) {
    read_ssid += char(EEPROM.read(firstAddress++));
  }
  return read_ssid;

  // eeprom 에서 ssid를 읽어옴.
  // 가장 첫 주소의 값은 ssid 문장의 길이를 나타냄.
  // 읽은 데이터를 String object로 리턴 함.
}
/*
 *  EEPROM에서 ssid를 읽어들이는 함수
 */
void write_ssid_to_eeprom( int address, String _ssid ) {

  for (int i = 0; i <= _ssid.length(); i++) {
    if (i == 0) {
      EEPROM.write(address++, _ssid.length());
    }
    else {
      EEPROM.write(address++, _ssid.charAt(i - 1));
    }
  }

  EEPROM.commit();

  // eeprom 에다가 ssid를 씀.
  // 가장 첫 주소의 값은 ssid 문장의 길이를 나타냄.
  // password의 주소 부분을 침범하지 않도록 ssid가 100자가 넘는지 확인해야 함..
  // password 주소 = 100번지 부터.. ssid는 0번지부터.. 즉 0~99로 100의 공간이 존재.
  // but 주소의 첫 바이트는 길이이므로 99자리가 남음.
  // 100 자리 이상일 경우에는 업데이트하지 않고 함수 종료
}

/*
 *  EEPROM에서 password를 읽어들이는 함수
 */
String read_password_from_eeprom( int firstAddress ) {
  String read_password = String();
  int ssid_length = int(EEPROM.read(firstAddress++));

  for (int forLen = 0; forLen < ssid_length; forLen++) {
    read_password += char(EEPROM.read(firstAddress++));
  }
  return read_password;
}

/*
 *  EEPROM에서 password를 읽어들이는 함수
 */
void write_password_to_eeprom(int address, String _password ) {

  for (int i = 0; i <= _password.length(); i++) {
    if (i == 0) {
      EEPROM.write(address++, _password.length());
    }
    else {
      EEPROM.write(address++, _password.charAt(i - 1));
    }
  }

  EEPROM.commit();
}
