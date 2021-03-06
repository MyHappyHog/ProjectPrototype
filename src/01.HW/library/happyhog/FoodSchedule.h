#ifndef __FOODSCHEDULE_H__
#define __FOODSCHEDULE_H__

#include "Setting.h"

#define DEFAULT_FOODSCHEDULE_FILENAME "/FoodSchedule.json"

#define NUM_ROTATION_KEY "numRotation"
#define TIME_KEY "time"

/// @brief		Food 스케줄을 담고 있는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

typedef struct _FoodScheduleList {
	struct _FoodScheduleList* nextSchedule;
	int numRotation;
	String time;
} FoodScheduleList;


class FoodSchedule : public Setting {
public:
	FoodSchedule(String fileName);
	FoodSchedule(String filePath, String fileName);
	virtual ~FoodSchedule();
	
	virtual bool deserialize(String json, bool rev = false);
	virtual String serialize(bool rev = false);

	void addSchedule(int numRotation, String time);
	void removeSchedule(FoodScheduleList* delSchedule);

	FoodScheduleList* getFoodScheduleHeader();
private :
	FoodScheduleList* schedule;
};

#endif