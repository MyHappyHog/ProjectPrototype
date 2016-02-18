#include <Arduino.h>
#include <ArduinoJson.h>

#include "Relay.h"

const char TEMPERATURE_KEY[] PROGMEM = TEMPERATURE_ARGUMENT_KEY;
const char HUMIDITY_KEY[] PROGMEM = HUMIDITY_ARGUMENT_KEY;

Relay::Relay(String fileName) : Relay("/", fileName) { }

Relay::Relay(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new RelayData;
	
	data->temperature[RELAY_POSITION] = DEFAULT_TEMPERATURE_RELAY;
	data->temperature[RELAY_STATE] = DEFAULT_STATE;

	data->humidity[RELAY_POSITION] = DEFAULT_HUMIDITY_RELAY;
	data->humidity[RELAY_STATE] = DEFAULT_STATE;
}

Relay::~Relay() {
	delete data;
}

bool Relay::deserialize(String json, bool rev) {
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
	data->temperature[RELAY_POSITION] = root[FPSTR(TEMPERATURE_KEY)][RELAY_POSITION];
	data->temperature[RELAY_STATE] = root[FPSTR(TEMPERATURE_KEY)][RELAY_STATE];

	data->humidity[RELAY_POSITION] = root[FPSTR(HUMIDITY_KEY)][RELAY_POSITION];
	data->humidity[RELAY_STATE] = root[FPSTR(HUMIDITY_KEY)][RELAY_STATE];
	
	if(rev) {
		Setting::setReversion(root["rev"].asString());
	}
	
	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;
	
	return true;
}
String Relay::serialize(bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// Relay Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	JsonArray& temperature = root.createNestedArray(FPSTR(TEMPERATURE_KEY));
	temperature.add(data->temperature[RELAY_POSITION]);
	temperature.add(data->temperature[RELAY_STATE]);
	
	JsonArray& humidity = root.createNestedArray(FPSTR(HUMIDITY_KEY));
	humidity.add(data->humidity[RELAY_POSITION]);
	humidity.add(data->humidity[RELAY_STATE]);

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