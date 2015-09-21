enum {outputTemperature = 5}; 
enum {relayMat = 6};

float checkTemperature(int outputpin);
void playRelay(float celsiustemp);

float celsiustemp = 0;

void setup()
{
  Serial.begin(9600); // 시리얼 통신을 열고 속도를 9600bps 로 사용한다.
  pinMode(relayMat, OUTPUT);
}

void loop() 
{
  celsiustemp = checkTemperature(outputTemperature);
  Serial.print(celsiustemp);
  playRelay(celsiustemp);
} 

float checkTemperature(int outputpin){
  
  float reading = analogRead(outputpin);  // 센서로 부터 자료값을 받는다.
  float voltage = reading * 5.0 / 1024.0;
  celsiustemp = (voltage - 0.5) * 100.0 ; 
  // 입력받은 자료값을 수정하여 필요한 자료값으로 바꾼다.
  delay(2000);
  
  return celsiustemp;
}

void playRelay(float celsiustemp){
    if(celsiustemp < 24.0){
    digitalWrite(relayMat, HIGH);  //24도 이하일 때 릴레이를 실행
  }
}
