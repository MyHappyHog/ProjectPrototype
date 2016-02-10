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
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<WIFI_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<WIFI_JSON_SIZE>;

	// JSON �м�
	JsonObject& root = jsonBuffer->parseObject(json);
	if( !root.success() ) {
		return -1;
	}

	// �м��� ������ �Է�
	data->ssid = root[SSID_KEY].asString();
	data->password = root[PASSWORD_KEY].asString();
	data->dropboxKey = root[DROPBOX_ACCESS_KEY].asString();

	return 0;
}
String Wifi::serialize() {
	// Jsonbuffer �����Ҵ�
	StaticJsonBuffer<WIFI_JSON_SIZE>* jsonBuffer = new StaticJsonBuffer<WIFI_JSON_SIZE>;

	// WIFI Data�� JSON �� ��ȯ
	JsonObject& root = jsonBuffer->createObject();

	root[SSID_KEY] = data->ssid;
	root[PASSWORD_KEY] = data->password;
	root[DROPBOX_ACCESS_KEY] = data->dropboxKey;

	// JSON�� ��Ʈ������ ��ȯ
	String json = "";
	root.printTo(json);

	// �����Ҵ��� �޸� ��ȯ
	delete jsonBuffer;

	return json;
}