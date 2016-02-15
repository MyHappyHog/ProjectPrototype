#ifndef __H3SCHEDULER_H__
#define __H3SCHEDULER_H__

#include <Stepper.h>

#define STEP_IN_1 16
#define STEP_IN_2 14
#define STEP_IN_3 12
#define STEP_IN_4 13

#define MOTER_STEP 200

/// @brief		Schedule을 받아 처리해주는 클래스. 현재는 푸드만 됨.
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class H3Scheduler {
public:
	H3Scheduler();
	H3Scheduler(int moterStep, int input1, int input2, int input3, int input4);
	~H3Scheduler();

	void runSchedule(FoodSchedule* schedule);

private:
	Stepper* motor;
};

#endif