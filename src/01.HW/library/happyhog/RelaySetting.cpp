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
	data->temperature = root[FPSTR(TEMPERATURE_KEY)];
	data->humidity = root[FPSTR(HUMIDITY_KEY)];
	
	// 동적할당한 메모리 반환
	delete jsonBuffer;
	
	return true;
}

String RelaySetting::serialize(bool rev) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<RELAY_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<RELAY_JSON_SIZE>;

	// Relay Data를 JSON 로 변환
	JsonObject& root = jsonBuffer->createObject();
	
	root[FPSTR(TEMPERATURE_KEY)] = data->temperature;
	root[FPSTR(HUMIDITY_KEY)] = data->humidity;

	// JSON을 스트링으로 변환
	String json = "";
	root.printTo(json);

	// 동적할당한 메모리 반환
	delete jsonBuffer;

	return json;
}

RelayPosition RelaySetting::getRelayData() {
	return *data;
}