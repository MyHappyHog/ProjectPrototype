#include "FS.h"
#include "H3FileSystem.h"

H3FileSystem::H3FileSystem() : H3FileSystem(false) { }
H3FileSystem::H3FileSystem(bool formatting) {
	spiffsReady = false;
	if (formatting && !SPIFFS.format()) {
		return ;
	}

	if (!SPIFFS.begin()) {
		return ;
	}
}
H3FileSystem::~H3FileSystem() { };

bool H3FileSystem::download(Setting* data) {
	String filePathName = data->getFilePath() + data->getFileName();
	
	if (!SPIFFS.exists(filePathName)) {
		return false;
	}

	File in = SPIFFS.open(filePathName, "r");
	if (!in) {
		return false;
	}

	in.setTimeout(0);
	String result = in.readString();
	in.close();
	
	return data->deserialize(result);
}

bool H3FileSystem::upload(Setting* data) {

	String filePathName = data->getFilePath() + data->getFileName();
	
	if (!SPIFFS.exists(filePathName)) {
		SPIFFS.remove(filePathName);
	}

	File out = SPIFFS.open(filePathName, "w");
	if (!out) {
		return false;
	}
	out.print(data->serialize());

	out.close();
	return true;
}