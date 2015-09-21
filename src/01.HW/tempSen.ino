int outputpin= A5; // 센서와 연결된 아날로그 핀 설정

void setup()
{
  Serial.begin(9600); // 시리얼 통신을 열고 속도를 9600bps 로 사용한다.
}

void loop()
{  
  int reading = analogRead(outputpin);  // 센서로 부터 자료값을 받는다.
  float voltage = reading * 5.0 / 1024.0;
  float celsiustemp = (voltage - 0.5) * 100 ; 
  float fahrenheittemp= celsiustemp * 9.0/5.0 + 32.0;
  // 입력받은 자료값을 수정하여 필요한 자료값으로 바꾼다.
  
  Serial.print(celsiustemp);
  Serial.println(" Celsius");
  Serial.print(fahrenheittemp);
  Serial.println(" Fahrenheit");
  Serial.println("----------------------");
  // 수정하여 나온 자료값을 출력한다.(섭씨, 화씨 둘다 출력)
  delay(1000);
} 
