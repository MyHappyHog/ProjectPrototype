#ifndef __RELAY_H__
#define __RELAY_H__

#define DEFAULT_TEMPERATURE_RELAY_PIN 12
#define DEFAULT_HUMIDITY_RELAY_PIN 13

/// @brief		릴레이를 제어하는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Relay {
public :
	Relay(int temperaturePin = DEFAULT_TEMPERATURE_RELAY_PIN, int humidityPin = DEFAULT_HUMIDITY_RELAY_PIN);
	virtual ~Relay();

	void run(SensingInfo* info, Enviroment* env, RelaySetting* relay);

private :
	int pin[2];
};

#endif