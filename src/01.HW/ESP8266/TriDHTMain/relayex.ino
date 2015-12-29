enum {outputTemperature = 5}; 
enum {relayMat = 6};

float checkTemperature(int outputpin){
  
  float reading = analogRead(outputpin);  // 센서로 부터 자료값을 받는다.
  float voltage = reading * 5.0 / 1024.0;
  celsiustemp = (voltage - 0.5) * 100.0 ;
  
  // 입력받은 자료값을 수정하여 필요한 자료값으로 바꾼다.
  
  return celsiustemp;
}

void playRelay(float celsiustemp){
  Serial.print(celsiustemp); 
  Serial.print("\n");

  celsiustemp = checkTemperature(outputTemperature);
  if(celsiustemp < 20.0){//조건달아야함
    digitalWrite(relayMat, LOW);  //24도 이하일 때 릴레이를 실행
  }
}
