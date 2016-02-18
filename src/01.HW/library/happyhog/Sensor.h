#ifndef __SENSOR_H__
#define __SENSOR_H__

#include <DHT.h>

#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 10   // percent of trimmed mean

#define DHT11_PIN_1 5
#define DHT11_PIN_2 4

#define NUM_SENSOR 2
#define MAX_COUNT NUM_OF_DATA / NUM_SENSOR

/// @brief		DHT 센서로 온, 습도를 센싱하는 클래스.
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Sensor {
public:
	Sensor();
	~Sensor();

	void begin();
	void Sensing(SensingInfo* info);

	bool getRequireUpdate();
	void setRequireUpdate(bool require);

private:
	void checkTemData(int i);
	void checkHumData(int i);
	void sort(double arr[], int num);
	double findMean(double arr[]);
	double findDeviation(double arr[]);
	double findMedian(double arr[]);
	double findTrimmed(double arr[], double percent);
	double zScore(double arr[]);
	double nomalization(double* tempOrHumid);

private:
	DHT* dht[NUM_SENSOR];
	uint32_t lastTime;

	double temperature[NUM_OF_DATA];
	double humidity[NUM_OF_DATA];

	double prevTemp;
	double prevHumid;
	int count;

	bool requireUpdate;
};

#endif