#include <Arduino.h>

#include "Setting.h"


Setting::Setting() {};
Setting::Setting(String& filePath, String& fileName) {
	this->filePath = filePath;
	this->fileName = fileName;
};

String& Setting::getFilePath() {
	return filePath;
}

String& Setting::getFileName() {
	return fileName;
}