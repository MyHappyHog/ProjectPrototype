#ifndef __ENVIROMENT_H__
#define __ENVIROMENT_H__

#include "Setting.h"

#define TEMPERATURE_ARRAY_KEY "temperature"
#define HUMIDITY_ARRAY_KEY "humidity"

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

class Enviroment : Setting {
public :
	Enviroment(String fileName);
	Enviroment(String filePath, String fileName);
	~Enviroment();

	int deserialize(String json);
	String serialize();

private :
	EnviromentData* data;
};

#endif