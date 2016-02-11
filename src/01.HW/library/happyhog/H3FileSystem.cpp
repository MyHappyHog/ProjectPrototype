
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

int H3FileSystem::download(Setting* data) {
	String filePathName = data->getFilePath() + data->getFileName();
	
	if (!SPIFFS.exists(filePathName)) {
		return -1;
	}

	File in = SPIFFS.open(filePathName, "r");
	if (!in) {
		return -1;
	}

	in.setTimeout(0);
	String result = in.readString();
	in.close();
	
	if (data->deserialize(result) != 0) {
		return -1;
	}

	return 0;
}
int H3FileSystem::upload(Setting* data) {

	String filePathName = data->getFilePath() + data->getFileName();
	
	if (!SPIFFS.exists(filePathName)) {
		SPIFFS.remove(filePathName);
	}

	File out = SPIFFS.open(filePathName, "w");
	if (!out) {
		return -1;
	}
	out.print(data->serialize());

	out.close();
	return 0;
}