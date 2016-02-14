#include <Arduino.h>

#include "FoodSchedule.h"
#include "H3Scheduler.h"
#include "time.h"

H3Scheduler::H3Scheduler() : H3Scheduler(MOTER_STEP, STEP_IN_1, STEP_IN_2, STEP_IN_3, STEP_IN_4) { }
H3Scheduler::H3Scheduler(int moterStep, int input1, int input2, int input3, int input4) {
	motor = new Stepper(moterStep, input1, input2, input3, input4);
	motor->setSpeed(10);
}
H3Scheduler::~H3Scheduler() {
	delete motor;
}

void H3Scheduler::runSchedule(FoodSchedule* schedule) {
	// 현재 시간 가져옴
	time_t now = time(nullptr);
	String currentTime = ctime(&now);

	// 현재 시간과 분 파싱
	int timeIndex = currentTime.indexOf(":");
	currentTime = currentTime.substring(timeIndex - 2, timeIndex + 3);
	
	// 스케줄 리스트를 가져옴.
	// 타임이 now 이거나 스케줄에 설정된 시간과 같으면 모터 회전
	// wdt disable 시켜주지 않으면 자동으로 리스타트 될 수 있음.
	wdt_disable();
	FoodScheduleList* p = schedule->getFoodScheduleHeader();
	while (p != nullptr) {
		if (p->time.equals("now")) {
			motor->step(MOTER_STEP / 4 * p->numRotation);
			FoodScheduleList* np = p->nextSchedule;
			schedule->removeSchedule(p);

			p = np;
		} 
		else if (p->time.equals(currentTime)) {
			motor->step(MOTER_STEP / 4 * p->numRotation);
			p = p->nextSchedule;
		} 
		else {
			p = p->nextSchedule;
		}

	}
	wdt_enable(0);
}