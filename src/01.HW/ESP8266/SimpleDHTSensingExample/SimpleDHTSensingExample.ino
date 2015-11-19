/* Simple DHT Sensing Example  */
/* Measurement Range: 0-50'C   */
/* Measurement Range: 20-90%RH */

#include <DHT.h>

#define DHTPIN1 4
#define DHTPIN2 14
#define DHTPIN3 5

/* Number of DHT and Type */
#define DHTTYPE DHT11
#define NUM_OF_DHT 3

// Initialize DHT sensor.
DHT dht1(DHTPIN1, DHTTYPE);
DHT dht2(DHTPIN2, DHTTYPE);
DHT dht3(DHTPIN3, DHTTYPE);

uint32_t lastreadtime;
void setup(void)
{
  // communication serial port
  Serial.begin(115200);

  dht1.begin();
  dht2.begin();
  dht3.begin();

  // init current time
  lastreadtime = millis();
  Serial.println("start sensing");
}

////////////// here is a loop code //////////////
void loop(void)
{
  uint32_t temperature[NUM_OF_DHT] = {0, };
  uint32_t humidity[NUM_OF_DHT] = {0, };

  // 현재 시간 저장
  uint32_t currenttime = millis();
  if ( (currenttime - lastreadtime) < 2000 ) {
    return ; // return last correct measurement
  }
  lastreadtime = currenttime;

  // 습도 정보 센싱 (내부에 센서의 값을 읽어오는 함수 있음)
  // 따라서 온도를 센싱하기 전에 습도를 먼저 센싱하는 것을 추천함.
  sensingHumidity(humidity);
  // 온도 정보 센싱
  sensingTemperature(temperature);

  // 센싱된 데이터 시리얼로 출력
  printSensingData(temperature, humidity);
}

void sensingTemperature(uint32_t temperature[]) {
  // 온도 센싱. (섭씨)
  // 파라미터로 true를 넘기면 화씨로 측정가능
  temperature[0] = (uint32_t)dht1.readTemperature();
  temperature[1] = (uint32_t)dht2.readTemperature();
  temperature[2] = (uint32_t)dht3.readTemperature();
}

void sensingHumidity(uint32_t humidity[]) {
  humidity[0] = (uint32_t)dht1.readHumidity();
  humidity[1] = (uint32_t)dht2.readHumidity();
  humidity[2] = (uint32_t)dht3.readHumidity();
}

void printSensingData(uint32_t temperature[], uint32_t humidity[]) {
  for (int i = 0; i < NUM_OF_DHT; i++) {
    Serial.print("DHT No.");
    Serial.print(i + 1);
    Serial.print("temperature: ");
    Serial.print(temperature[i]);
    Serial.print(", humidity: ");
    Serial.println(humidity[i]);
  }
  Serial.println();
}


