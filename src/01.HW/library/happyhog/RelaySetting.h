#ifndef __RELAYSETTING_H__
#define __RELAYSETTING_H__

#include "Setting.h"

#define DEFAULT_RELAY_FILENAME "/relaySetting.json"

#define RELAY_JSON_SIZE 200
#define DEFAULT_STATE 0

enum default_relays { DEFAULT_TEMPERATURE_RELAY, DEFAULT_HUMIDITY_RELAY };
enum relay_index { RELAY_POSITION, RELAY_STATE };

typedef struct _RelayData {
	int temperature[2];
	int humidity[2];
} RelayData;

/// @brief		릴레이 정보를 담고 있는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class RelaySetting : public Setting {
public :
	RelaySetting(String fileName);
	RelaySetting(String filePath, String fileName);
	virtual ~RelaySetting();

	virtual bool deserialize(String json, bool rev = false);
	virtual String serialize(bool rev = false);

private :
	RelayData* data;
};

#endif