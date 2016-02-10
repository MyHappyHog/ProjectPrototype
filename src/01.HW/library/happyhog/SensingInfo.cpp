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
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// �м��� ������ �Է�
	data->temperature = root[TEMPERATURE_KEY];
	data->humidity = root[HUMIDITY_KEY];

	return 0;
}

String SensingInfo::serialize() {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// Senser Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	root[TEMPERATURE_KEY] = data->temperature;
	root[HUMIDITY_KEY] = data->humidity;

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}

