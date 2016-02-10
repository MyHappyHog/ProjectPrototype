#include <Arduino.h>
#include <ArduinoJson.h>
#include "SensingInfo.h"

SensingInfo::SensingInfo(String fileName) : SensingInfo(String("/"), fileName) { }

SensingInfo::SensingInfo(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new SensorData;
	data->temperature = data->humidity = 0;
}

SensingInfo::~SensingInfo() {
	delete data;
}

int SensingInfo::deserialize(String json) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// JSON 분석
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// 분석한 데이터 입력
	data->temperature = root[TEMPERATURE_KEY];
	data->humidity = root[HUMIDITY_KEY];

	return 0;
}

String SensingInfo::serialize() {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// Senser Data를 JSON 로 변환
	JsonObject& root = jsonBuffer->createObject();
	root[TEMPERATURE_KEY] = data->temperature;
	root[HUMIDITY_KEY] = data->humidity;

	// JSON을 스트링으로 변환
	String json = "";
	root.printTo(json);

	// 동적할당한 메모리 반환
	delete jsonBuffer;

	return json;
}

