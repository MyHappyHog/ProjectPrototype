#include <Arduino.h>
#include <ArduinoJson.h>

#include "RelaySetting.h"

const char TEMPERATURE_KEY[] PROGMEM = TEMPERATURE_ARGUMENT_KEY;
const char HUMIDITY_KEY[] PROGMEM = HUMIDITY_ARGUMENT_KEY;

RelaySetting::RelaySetting(String fileName) : RelaySetting("/", fileName) { }

RelaySetting::RelaySetting(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new RelayPosition;
	
	data->temperature = DEFAULT_TEMPERATURE_RELAY;
	data->humidity = DEFAULT_HUMIDITY_RELAY;
}

RelaySetting::~RelaySetting() {
	delete data;
}

bool RelaySetting::deserialize(String json, bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// �м��� ������ �Է�
	// ��, ������ ������ �������� ������ ���� �迭�� �Ǿ������� �ε����� ������ ��ġ = 0, ���� ���� = 1 �� �Ǿ� ����.
	data->temperature = root[FPSTR(TEMPERATURE_KEY)];
	data->humidity = root[FPSTR(HUMIDITY_KEY)];
	
	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;
	
	return true;
}

String RelaySetting::serialize(bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// Relay Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	
	root[FPSTR(TEMPERATURE_KEY)] = data->temperature;
	root[FPSTR(HUMIDITY_KEY)] = data->humidity;

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}

RelayPosition RelaySetting::getRelayData() {
	return *data;
}