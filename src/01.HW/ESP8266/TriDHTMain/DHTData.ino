
void getDHTData(int* temperature, int* humidity) {

  int temp[NUM_OF_DHT], humid[NUM_OF_DHT];
  
  temp[0] = (int)dht1.readTemperature();
  humid[0] = (int)dht1.readHumidity();
  
  temp[1] = (int)dht2.readTemperature();
  humid[1] = (int)dht2.readHumidity();
  
  temp[2] = (int)dht3.readTemperature();
  humid[2] = (int)dht3.readHumidity();
  
  for (int i = 0; i < NUM_OF_DHT; i++) {
    
    
    if (TEMP_MIN <= temp[i] && temp[i] <= TEMP_MAX) {
      temperature[i] = temp[i];
    }
    if(HUMI_MIN <= humid[i] && humid[i] <= HUMI_MAX) {
      humidity[i] = humid[i];
    }
    
  }
}

void printDHTData(int* temp, int* humid) {
  for(int i = 0; i < NUM_OF_DHT; i++){
    
    Serial.print("DHT No. ");
    Serial.print(i);
    Serial.print(", temp: ");
    Serial.print(temp[i]);
    Serial.print(", humidity: ");
    Serial.print(humid[i]);
    Serial.println();
  }
}
