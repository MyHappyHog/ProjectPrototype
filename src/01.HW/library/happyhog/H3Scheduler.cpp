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
	// ���� �ð� ������
	time_t now = time(nullptr);
	String currentTime = ctime(&now);

	// ���� �ð��� �� �Ľ�
	int timeIndex = currentTime.indexOf(":");
	currentTime = currentTime.substring(timeIndex - 2, timeIndex + 3);
	
	// ������ ����Ʈ�� ������.
	// Ÿ���� now �̰ų� �����ٿ� ������ �ð��� ������ ���� ȸ��
	// wdt disable �������� ������ �ڵ����� ����ŸƮ �� �� ����.
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