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

bool Wifi::deserialize(String json, bool rev) {
	// Jsonbuffer 동적할당
	StaticJsonBuffer<WIFI_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<WIFI_JSON_SIZE>;

	// JSON 분석
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		delete jsonBuffer;
		return false;
	}

	// 분석한 데이터 입력
	data->ssid = root[SSID_KEY].asString();
	data->password = root[PASSWORD_KEY].asString();
	data->dropboxKey = root[DROPBOX_ACCESS_KEY].asString();
	
	delete jsonBuffer;

	return true;
}

String Wifi::serialize(bool rev) {
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

String Wifi::getSSID() {
	return data->ssid;
}

String Wifi::getPassword() {
	return data->password;
}

String Wifi::getDropboxKey() {
	return data->dropboxKey;
}

void Wifi::setData(WIFIData* wifiData) {
	if (data != nullptr) {
		delete data;
	}

	data = wifiData;
}