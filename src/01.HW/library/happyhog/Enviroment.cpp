#include <Arduino.h>
#include <ArduinoJson.h>

#include "Enviroment.h"

Enviroment::Enviroment(String& fileName) {
	Enviroment(String("/"), fileName);
}

Enviroment::Enviroment(String& filePath, String& fileName) : Setting(filePath, fileName) {
	data = new EnviromentData;
	data->temperature[MAX_TEMPERATURE] = DEFAULT_MAX_TEMPERATURE;
	data->temperature[MIN_TEMPERATURE] = DEFAULT_MIN_TEMPERATURE;
	data->humidity[MAX_HUMIDITY] = DEFAULT_MAX_HUMIDITY;
	data->humidity[MIN_HUMIDITY] = DEFAULT_MIN_HUMIDITY;
}

Enviroment::~Enviroment() {
	delete data;
}

int Enviroment::deserialize(String& json) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// �м��� ������ �Է�
	// ��, ���� ���� �迭�� �Ǿ������� �ε����� max = 0, min = 1 ���� �Ǿ� ����.
	data->temperature[MAX_TEMPERATURE] = root[TEMPERATURE_ARRAY_KEY][MAX_TEMPERATURE];
	data->temperature[MIN_TEMPERATURE] = root[TEMPERATURE_ARRAY_KEY][MIN_TEMPERATURE];
	data->humidity[MAX_HUMIDITY] = root[HUMIDITY_ARRAY_KEY][MAX_HUMIDITY];
	data->humidity[MIN_HUMIDITY] = root[HUMIDITY_ARRAY_KEY][MIN_HUMIDITY];

	return 0;
}
String Enviroment::serialize() {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// Senser Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	JsonArray& temperature = root.createNestedArray(TEMPERATURE_ARRAY_KEY);
	temperature.add(data->temperature[MAX_TEMPERATURE]);
	temperature.add(data->temperature[MIN_TEMPERATURE]);
	
	JsonArray& humidity = root.createNestedArray(HUMIDITY_ARRAY_KEY);
	humidity.add(data->humidity[MAX_HUMIDITY]);
	humidity.add(data->humidity[MIN_HUMIDITY]);

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}