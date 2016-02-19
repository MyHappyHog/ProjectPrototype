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
	// Jsonbuffer 동적할당
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// JSON 분석
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// 분석한 데이터 입력
	// 온, 습도 각각 배열로 되어있으며 인덱스는 max = 0, min = 1 으로 되어 있음.
	data->temperature[MAX_TEMPERATURE] = root[FPSTR(TEMPERATURE_KEY)][MAX_TEMPERATURE];
	data->temperature[MIN_TEMPERATURE] = root[FPSTR(TEMPERATURE_KEY)][MIN_TEMPERATURE];
	data->humidity[MAX_HUMIDITY] = root[FPSTR(HUMIDITY_KEY)][MAX_HUMIDITY];
	data->humidity[MIN_HUMIDITY] = root[FPSTR(HUMIDITY_KEY)][MIN_HUMIDITY];
	
	delete jsonBuffer;

	return true;
}
String Enviroment::serialize(bool rev) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<ENVIROMENT_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<ENVIROMENT_JSON_SIZE>;

	// Enviroment Data를 JSON 로 변환
	JsonObject& root = jsonBuffer->createObject();
	JsonArray& temperature = root.createNestedArray(FPSTR(TEMPERATURE_KEY));
	temperature.add(data->temperature[MAX_TEMPERATURE]);
	temperature.add(data->temperature[MIN_TEMPERATURE]);
	
	JsonArray& humidity = root.createNestedArray(FPSTR(HUMIDITY_KEY));
	humidity.add(data->humidity[MAX_HUMIDITY]);
	humidity.add(data->humidity[MIN_HUMIDITY]);

	// JSON을 스트링으로 변환
	String json = "";
	root.printTo(json);

	// 동적할당한 메모리 반환
	delete jsonBuffer;

	return json;
}

EnviromentData Enviroment::getEnviromentData() {
	return *data;
}