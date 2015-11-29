
/* Measurement Range: 0-50'C*/
#define TEMP_MIN 0
#define TEMP_MAX 50

/* Measurement Range: 20-90%RH*/
#define HUMI_MIN 20
#define HUMI_MAX 90

#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 20   // percent of trimmed mean


void getTemData(double* temp, int i) {

      temp[i*3 - 1] = (double)dht1.readTemperature();
      temp[i*3] = (double)dht2.readTemperature();
      temp[i*3 + 1] = (double)dht3.readTemperature();

}


void getHumData(double* humid, int i) {

      humid[i*3 - 1] = (double)dht1.readHumidity();
      humid[i*3] = (double)dht2.readHumidity();
      humid[i*3 + 1] = (double)dht3.readHumidity();
  
}

void printDHTData(double temp, double humid) {
 
    Serial.print(", temp: ");
    Serial.print(temp);
    Serial.print(", humidity: ");
    Serial.print(humid);
    Serial.println();
  
}
