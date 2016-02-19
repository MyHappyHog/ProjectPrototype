#ifndef __ENVIROMENT_H__
#define __ENVIROMENT_H__

#include "Setting.h"

#define DEFAULT_ENVIROMENT_FILENAME "/EnviromentSetting.json"
#define ENVIROMENT_JSON_SIZE 400

#define DEFAULT_MAX_TEMPERATURE 28
#define DEFAULT_MIN_TEMPERATURE 18

#define DEFAULT_MAX_HUMIDITY 50
#define DEFAULT_MIN_HUMIDITY 30

enum temperatrue_index { MAX_TEMPERATURE, MIN_TEMPERATURE };
enum humidity_index { MAX_HUMIDITY, MIN_HUMIDITY };

typedef struct _EnviromentData {
	int temperature[2];
	int humidity[2];
} EnviromentData;

/// @brief		사용자가 설정한 온, 습도 정보를 담고 있는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Enviroment : public Setting {
public :
	Enviroment(String fileName);
	Enviroment(String filePath, String fileName);
	virtual ~Enviroment();

	virtual bool deserialize(String json, bool rev = false);
	virtual String serialize(bool rev = false);

private :
	EnviromentData* data;
};

#endif