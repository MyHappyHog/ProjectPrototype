#ifndef __SENSINGINFO_H__
#define __SENSINGINFO_H__

#include "Setting.h"

#define TEMPERATURE_KEY "temperature"
#define HUMIDITY_KEY "humidity"

#define SENSORDATA_JSON_SIZE 200

typedef struct _SensorData {
  double temperature;
  double humidity;
} SensorData;

/// @brief		Sensing된 데이터를 담고 있는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class SensingInfo : public Setting {
public :
	SensingInfo(String fileName);
	SensingInfo(String filePath, String fileName);
	virtual ~SensingInfo();
	
	virtual int deserialize(String json);
	virtual String serialize();

private :
	SensorData* data;
};

#endif