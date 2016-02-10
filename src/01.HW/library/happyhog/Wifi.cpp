#include <Arduino.h>
#include <ArduinoJson.h>

#include "Wifi.h"

Wifi::Wifi(String fileName) : Wifi("/", fileName) { }

Wifi::Wifi(String filePath, String fileName) : Setting(filePath, fileName) {
	data = new WIFIData;
	data->ssid = data->password = data->dropboxKey = "";
}

Wifi::~Wifi() {
	delete data;
}

int Wifi::deserialize(String json) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<WIFI_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<WIFI_JSON_SIZE>;

	// JSON 분석
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// 분석한 데이터 입력
	data->ssid = root[SSID_KEY].asString();
	data->password = root[PASSWORD_KEY].asString();
	data->dropboxKey = root[DROPBOX_ACCESS_KEY].asString();

	return 0;
}
String Wifi::serialize() {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<WIFI_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<WIFI_JSON_SIZE>;

	// WIFI Data를 JSON 로 변환
	JsonObject& root = jsonBuffer->createObject();

	root[SSID_KEY] = data->ssid;
	root[PASSWORD_KEY] = data->password;
	root[DROPBOX_ACCESS_KEY] = data->dropboxKey;

	// JSON을 스트링으로 변환
	String json = "";
	root.printTo(json);

	// 동적할당한 메모리 반환
	delete jsonBuffer;

	return json;
}