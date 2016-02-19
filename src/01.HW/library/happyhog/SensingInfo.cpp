#include <Arduino.h>
#include <ArduinoJson.h>
#include "SensingInfo.h"

const char TEMPERATURE_KEY[] PROGMEM = TEMPERATURE_ARGUMENT_KEY;
const char HUMIDITY_KEY[] PROGMEM = HUMIDITY_ARGUMENT_KEY;

SensingInfo::SensingInfo(String fileName) : SensingInfo(String("/"), fileName) { }

SensingInfo::SensingInfo(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new SensorData;
	data->temperature = data->humidity = 0;
}

SensingInfo::~SensingInfo() {
	delete data;
}

bool SensingInfo::deserialize(String json, bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// �м��� ������ �Է�
	data->temperature = root[FPSTR(TEMPERATURE_KEY)];
	data->humidity = root[FPSTR(HUMIDITY_KEY)];
	if(rev) {
		Setting::setReversion(root["rev"].asString());
	}
	
	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return true;
}

String SensingInfo::serialize(bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<SENSORDATA_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<SENSORDATA_JSON_SIZE>;

	// Senser Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	root[FPSTR(TEMPERATURE_KEY)] = data->temperature;
	root[FPSTR(HUMIDITY_KEY)] = data->humidity;
	if(rev) {
		root["rev"] = Setting::getReversion();
	}

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;
	
	return json;
}

SensorData SensingInfo::getSensorData() {
	return *data;
}