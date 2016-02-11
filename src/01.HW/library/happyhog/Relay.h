#ifndef __RELAY_H__
#define __RELAY_H__

#include "Setting.h"

#define TEMPERATURE_RELAY_KEY "temperature"
#define HUMIDITY_RELAY_KEY "humidity"

#define RELAY_JSON_SIZE 200
#define DEFAULT_STATE 0

enum default_relays { DEFAULT_TEMPERATURE_RELAY = 1, DEFAULT_HUMIDITY_RELAY };
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

class Relay : public Setting {
public :
	Relay(String fileName);
	Relay(String filePath, String fileName);
	virtual ~Relay();

	virtual bool deserialize(String json);
	virtual String serialize();

private :
	RelayData* data;
};

#endif