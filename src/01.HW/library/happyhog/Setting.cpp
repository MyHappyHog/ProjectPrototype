#include <Arduino.h>
#include <ArduinoJson.h>
#include "Setting.h"

Setting::Setting() {};
Setting::Setting(String& filePath, String& fileName) {
	this->filePath = filePath;
	this->fileName = fileName;
	reversion = "3e4404ddb9";
};
Setting::~Setting() { }

String Setting::getFilePath() {
	return filePath;
}

String Setting::getFileName() {
	return fileName;
}

String Setting::getReversion() {
	return reversion;
}

bool Setting::parseReversion(String json) {
	DynamicJsonBuffer jsonBuffer;

	JsonObject& root = jsonBuffer.parseObject(json);
	if (!root.success()) {
		return false;
	}

	reversion = root["rev"].asString();

	return true;
}