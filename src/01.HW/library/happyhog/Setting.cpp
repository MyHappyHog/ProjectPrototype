#include <Arduino.h>
#include <ArduinoJson.h>
#include "Setting.h"

Setting::Setting() : Setting(String(""), String("")) { };
Setting::Setting(String filePath, String fileName) {
	this->filePath = filePath;
	this->fileName = fileName;
	reversion = "3e4404ddb9"; // dummy
	cursor="";
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

bool Setting::setReversion(String rev) {
	reversion = rev;
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


String Setting::getCurrentCursor() {
	return cursor;
}

bool Setting::parseCursor(String json) {
	DynamicJsonBuffer jsonBuffer;

	JsonObject& root = jsonBuffer.parseObject(json);
	if (!root.success()) {
		return false;
	}

	cursor = root["cursor"].asString();

	return true;
}
