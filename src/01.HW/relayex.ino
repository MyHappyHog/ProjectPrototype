#define RELAY1 6
int outputpin= 5; // 센서와 연결된 아날로그 핀 설정

void setup()
{
  Serial.begin(9600); // 시리얼 통신을 열고 속도를 9600bps 로 사용한다.
  pinMode(RELAY1, OUTPUT);
}

void loop()
{
  int reading = analogRead(outputpin);  // 센서로 부터 자료값을 받는다.
  float voltage = reading * 5.0 / 1024.0;
  float celsiustemp = (voltage - 0.5) * 100 ; 
  // 입력받은 자료값을 수정하여 필요한 자료값으로 바꾼다.

  if(celsiustemp < 24){
    digitalWrite(RELAY1, LOW);  //24도 이하일 때 릴레이를 실행
  }
} 

