#include <Arduino.h>
#include <ArduinoJson.h>

#include "SensingInfo.h"
#include "Enviroment.h"
#include "RelaySetting.h"

#include "Relay.h"
Relay::	Relay(int temperaturePin, int humidityPin) { 
	pin[0] = temperaturePin;
	pin[1] = humidityPin;

	// init pin
	pinMode(pin[0], OUTPUT);
	pinMode(pin[1], OUTPUT);

	digitalWrite(pin[0], LOW);
	digitalWrite(pin[1], LOW);
}

Relay::~Relay() { }

void Relay::run(SensingInfo* info, Enviroment* env, RelaySetting* relay) {
	SensorData sensingData = info->getSensorData();
	EnviromentData envData = env->getEnviromentData();
	RelayPosition relayPosition = relay->getRelayData();

	if (sensingData.temperature < envData.temperature[MIN_TEMPERATURE]) {
		digitalWrite(pin[relayPosition.temperature], HIGH);
	} else if (sensingData.temperature > envData.temperature[MAX_TEMPERATURE]) {
		digitalWrite(pin[relayPosition.temperature], LOW);
	}

	if (sensingData.humidity < envData.humidity[MIN_HUMIDITY]) {
		digitalWrite(pin[relayPosition.humidity], HIGH);
	} else if (sensingData.humidity> envData.humidity[MAX_HUMIDITY]) {
		digitalWrite(pin[relayPosition.humidity], LOW);
	}
}