#ifndef __RELAYSETTING_H__
#define __RELAYSETTING_H__

#include "Setting.h"

#define DEFAULT_RELAYSETTING_FILENAME "/RelaySetting.json"

#define RELAY_JSON_SIZE 200

enum default_relays { DEFAULT_TEMPERATURE_RELAY, DEFAULT_HUMIDITY_RELAY };

typedef struct _RelayPosition {
	int temperature;
	int humidity;
} RelayPosition;

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

	RelayPosition getRelayData();

private :
	RelayPosition* data;
};

#endif