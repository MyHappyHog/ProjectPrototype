#include <Arduino.h>
#include <ArduinoJson.h>
#include "SensingInfo.h"

#include "Sensor.h"

const char TEMPERATURE_KEY[] PROGMEM = TEMPERATURE_ARGUMENT_KEY;
const char HUMIDITY_KEY[] PROGMEM = HUMIDITY_ARGUMENT_KEY;

Sensor::Sensor() {
	dht[0] = new DHT(DHT11_PIN_1, DHT11);
	dht[1] = new DHT(DHT11_PIN_2, DHT11);

	count = prevTemp = prevHumid = 0;
	requireUpdate = false;
}

Sensor::~Sensor() {
	delete dht[0];
	delete dht[1];
}

void Sensor::begin() {
	dht[0]->begin();
	dht[1]->begin();
}

void Sensor::Sensing(SensingInfo* info) {
	uint32_t currentTime = millis();
	if ( (currentTime - lastTime) > 2000 ) {
		
		if (count >= MAX_COUNT) {
			StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>; 
			JsonObject& root = jsonBuffer->createObject();
			
			root[FPSTR(TEMPERATURE_KEY)] = prevTemp = nomalization(temperature);
			root[FPSTR(HUMIDITY_KEY)] = prevHumid = nomalization(humidity);
			
			String SensingData = "";
			
			root.printTo(SensingData);
			info->deserialize(SensingData);

			delete jsonBuffer;
			
			requireUpdate = true;
			count = 0;
		}

		checkHumData(count);
		checkTemData(count);
		count++;

		lastTime = currentTime;
	}
}

bool Sensor::getRequireUpdate() {
	return requireUpdate;
}

void Sensor::setRequireUpdate(bool require) {
	requireUpdate = require;
}

void Sensor::checkTemData(int i) {
  temperature[i * 2] = (double)dht[0]->readTemperature();
  temperature[i * 2 + 1] = (double)dht[1]->readTemperature();

  if (isnan(temperature[i * 2])) temperature[i * 2] = prevTemp;
  if (isnan(temperature[i * 2 + 1])) temperature[i * 2 + 1] = prevTemp;
}

void Sensor::checkHumData(int i) {
  humidity[i * 2] = (double)dht[0]->readHumidity();
  humidity[i * 2 + 1] = (double)dht[1]->readHumidity();
  
  if (isnan(humidity[i * 2])) humidity[i * 2] = prevHumid;
  if (isnan(humidity[i * 2 + 1])) humidity[i * 2 + 1] = prevHumid;
}

void Sensor::sort(double arr[], int num) {
	boolean checkChange = false;
	for (int i = 0; i < num - 1; i++) {
		for (int j = 0; j < num - 1 - i; j++) {
			if (arr[j] > arr[j + 1]) {
				double temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = temp;
				checkChange = true;
			}
		}
		if (checkChange == false) {
			return;
		}
	}
}

double Sensor::findMean(double arr[]) {
	double addAll = 0, meanResult = 0;
	for (int i = 0; i < NUM_OF_DATA; i++) {
		addAll += arr[i];
	}
	meanResult = addAll / double(NUM_OF_DATA);
	return meanResult;
}

double Sensor::findDeviation(double arr[]) {
	double total = 0, devResult = 0, mean = findMean(arr);

	for (int i = 0; i < NUM_OF_DATA; i++) {
		total += (arr[i] - mean) * (arr[i] - mean);
	}
	if (total != 0) {
		total = total / double(NUM_OF_DATA);
		total = sqrt(total);
		devResult += total;
	}

	return devResult;
}

double Sensor::findMedian(double arr[]) {
	sort(arr, NUM_OF_DATA);
	/////////////////////////////////test
	//  Serial.print("sorting\n");
	//  testingArray(arr);
	////////////////////////////////

	int middle = NUM_OF_DATA / 2;
	if (NUM_OF_DATA % 2 ) {
		return (arr[middle]);
	}
	else {
		return (arr[middle - 1] + arr[middle]) / 2.0;
	}
}

double Sensor::findTrimmed(double arr[], double percent) {
	
  double median = findMedian(arr);
  double trim = NUM_OF_DATA * (percent / 100.0);
  for (int i = 0; i < trim; i++) {
    arr[i] = median;
    arr[(NUM_OF_DATA - i) - 1] = median;
  }
  /////////////////////////////////test
  //  Serial.print("trimmed\n");
  //  testingArray(arr);
  ////////////////////////////////

  return findMean(arr);
}

double Sensor::zScore(double arr[]) {
	double mean = findMean(arr), dev = findDeviation(arr);
	for (int i = 0; i < NUM_OF_DATA; i++) {
		double zNum = (mean - arr[i]) / dev;
		if (zNum > 1 || zNum < -1) {
			arr[i] = mean;
		}
	}

	return findMean(arr);
}

double Sensor::nomalization(double* tempOrHumid) {
  findTrimmed(tempOrHumid, TRIM_PERCENT);
  return zScore(tempOrHumid);
}