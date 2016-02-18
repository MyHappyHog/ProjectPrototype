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
	// Jsonbuffer 동적할당
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// JSON 분석
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// 분석한 데이터 입력
	// 온, 습도를 조절할 릴레이의 정보가 각각 배열로 되어있으며 인덱스는 릴레이 위치 = 0, 현재 상태 = 1 로 되어 있음.
	data->temperature[RELAY_POSITION] = root[FPSTR(TEMPERATURE_KEY)][RELAY_POSITION];
	data->temperature[RELAY_STATE] = root[FPSTR(TEMPERATURE_KEY)][RELAY_STATE];

	data->humidity[RELAY_POSITION] = root[FPSTR(HUMIDITY_KEY)][RELAY_POSITION];
	data->humidity[RELAY_STATE] = root[FPSTR(HUMIDITY_KEY)][RELAY_STATE];
	
	if(rev) {
		Setting::setReversion(root["rev"].asString());
	}
	
	// 동적할당한 메모리 반환
	delete jsonBuffer;
	
	return true;
}
String Relay::serialize(bool rev) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// Relay Data를 JSON 로 변환
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

	// JSON을 스트링으로 변환
	String json = "";
	root.printTo(json);

	// 동적할당한 메모리 반환
	delete jsonBuffer;

	return json;
}