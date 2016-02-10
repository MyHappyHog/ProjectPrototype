#include "Setting.h"

#include <Arduino.h>

Setting::Setting() {};

String& Setting::getFilePath() {
	return filePath;
}
String& Setting::getFileName() {
	return fileName;
}