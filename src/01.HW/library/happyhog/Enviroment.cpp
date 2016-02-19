#include <Arduino.h>
#include <ArduinoJson.h>

#include "Enviroment.h"

const char TEMPERATURE_KEY[] PROGMEM = TEMPERATURE_ARGUMENT_KEY;
const char HUMIDITY_KEY[] PROGMEM = HUMIDITY_ARGUMENT_KEY;

Enviroment::Enviroment(String fileName) : Enviroment("/", fileName) { }

Enviroment::Enviroment(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new EnviromentData;
	data->temperature[MAX_TEMPERATURE] = DEFAULT_MAX_TEMPERATURE;
	data->temperature[MIN_TEMPERATURE] = DEFAULT_MIN_TEMPERATURE;
	data->humidity[MAX_HUMIDITY] = DEFAULT_MAX_HUMIDITY;
	data->humidity[MIN_HUMIDITY] = DEFAULT_MIN_HUMIDITY;
}

Enviroment::~Enviroment() {
	delete data;
}

bool Enviroment::deserialize(String json, bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// �м��� ������ �Է�
	// ��, ���� ���� �迭�� �Ǿ������� �ε����� max = 0, min = 1 ���� �Ǿ� ����.
	data->temperature[MAX_TEMPERATURE] = root[FPSTR(TEMPERATURE_KEY)][MAX_TEMPERATURE];
	data->temperature[MIN_TEMPERATURE] = root[FPSTR(TEMPERATURE_KEY)][MIN_TEMPERATURE];
	data->humidity[MAX_HUMIDITY] = root[FPSTR(HUMIDITY_KEY)][MAX_HUMIDITY];
	data->humidity[MIN_HUMIDITY] = root[FPSTR(HUMIDITY_KEY)][MIN_HUMIDITY];
	
	delete jsonBuffer;

	return true;
}
String Enviroment::serialize(bool rev) {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// Enviroment Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();
	JsonArray& temperature = root.createNestedArray(FPSTR(TEMPERATURE_KEY));
	temperature.add(data->temperature[MAX_TEMPERATURE]);
	temperature.add(data->temperature[MIN_TEMPERATURE]);
	
	JsonArray& humidity = root.createNestedArray(FPSTR(HUMIDITY_KEY));
	humidity.add(data->humidity[MAX_HUMIDITY]);
	humidity.add(data->humidity[MIN_HUMIDITY]);

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}

EnviromentData Enviroment::getEnviromentData() {
	return *data;
}