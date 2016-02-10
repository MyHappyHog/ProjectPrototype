#include <Arduino.h>
#include <ArduinoJson.h>

#include "Relay.h"

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

int Relay::deserialize(String json) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// �м��� ������ �Է�
	// ��, ������ ������ �������� ������ ���� �迭�� �Ǿ������� �ε����� ������ ��ġ = 0, ���� ���� = 1 �� �Ǿ� ����.
	data->temperature[RELAY_POSITION] = root[TEMPERATURE_RELAY_KEY][RELAY_POSITION];
	data->temperature[RELAY_STATE] = root[TEMPERATURE_RELAY_KEY][RELAY_STATE];

	data->humidity[RELAY_POSITION] = root[HUMIDITY_RELAY_KEY][RELAY_POSITION];
	data->humidity[RELAY_STATE] = root[HUMIDITY_RELAY_KEY][RELAY_STATE];

	return 0;
}
String Relay::serialize() {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// Relay Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	JsonArray& temperature = root.createNestedArray(TEMPERATURE_RELAY_KEY);
	temperature.add(data->temperature[RELAY_POSITION]);
	temperature.add(data->temperature[RELAY_STATE]);
	
	JsonArray& humidity = root.createNestedArray(HUMIDITY_RELAY_KEY);
	humidity.add(data->humidity[RELAY_POSITION]);
	humidity.add(data->humidity[RELAY_STATE]);

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}