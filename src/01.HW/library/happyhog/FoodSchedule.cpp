#include <Arduino.h>
#include <ArduinoJson.h>

#include "FoodSchedule.h"

FoodSchedule::FoodSchedule(String fileName) : FoodSchedule(String("/"), fileName) { }
FoodSchedule::FoodSchedule(String filePath, String fileName) : Setting(filePath, fileName) { }
FoodSchedule::~FoodSchedule() {
	while (schedule != NULL) {
		removeSchedule(schedule);
	}
}

bool FoodSchedule::deserialize(String json) {
	DynamicJsonBuffer jsonBuffer;

	// json ��Ʈ���� ���ȣ�� ������ �迭�� ����� ��.
	String jsonArray = "[C]";
	jsonArray.replace("C", json);

	// Array �Ľ�
	JsonArray& scheduleArray = jsonBuffer.parseArray(jsonArray);
	if (!scheduleArray.success()) {
		return false;
	}

	// �Ľ��� Json Array�� �����ͷ� ��ȯ
	for (JsonArray::iterator it = scheduleArray.begin(); it != scheduleArray.end(); ++it) {
		JsonObject& obj = *it;
		addSchedule(obj[NUM_ROTATION_KEY], obj[TIME_KEY].asString());
	}

	return true;
}

String FoodSchedule::serialize() {
	// json array ����
	DynamicJsonBuffer jsonBuffer;
	JsonArray& scheduleArray = jsonBuffer.createArray();

	// ��� schedule �����͸� json array�� ��ȯ
	FoodScheduleList* p = schedule;
	while (p != NULL) {
		// object ���� �� ������ ��ȯ
		JsonObject& node = jsonBuffer.createObject();
		node[NUM_ROTATION_KEY] = p->numRotation;
		node[TIME_KEY] = p->time;
		
		// object�� array�� �߰�
		scheduleArray.add(node);

		p = p->nextSchedule;
	}
	
	// json array�� ��Ʈ������ ��ȯ
	String result;
	scheduleArray.printTo(result);

	// ��ȯ�� ��Ʈ�� ��ȯ
	return result;
};

void FoodSchedule::addSchedule(int numRotation, String time) {
	// ������ ����Ʈ�� ����� ���� ��
	if (schedule == NULL) {
		schedule = new FoodScheduleList;
		schedule->nextSchedule = NULL;
		schedule->numRotation = numRotation;
		schedule->time = time;
	} 
	// ����� ���� �� ��.
	else {
		FoodScheduleList* p = schedule;
		while ( p->nextSchedule != NULL ) {
			p = p->nextSchedule;
		}

		p->nextSchedule = new FoodScheduleList;
		p->nextSchedule->nextSchedule = NULL;
		p->nextSchedule->numRotation = numRotation;
		p->nextSchedule->time = time;
	}
}

void FoodSchedule::removeSchedule(FoodScheduleList* delSchedule) {
	if (schedule == NULL || delSchedule == NULL) {
		return ;
	}
	
	// ������ ��尡 ����� ��
	if (schedule == delSchedule) {
		FoodScheduleList* np = schedule->nextSchedule;
		delete schedule;

		schedule = np;
	}
	// ����� �ƴ� ��
	// ��带 ã�� �����ϰ� ������ ��� �� ��忡 �� ��带 �̾� ��.
	else {
		FoodScheduleList* p = schedule; 
		while (p->nextSchedule != delSchedule) {
			p = p->nextSchedule;
		}

		FoodScheduleList* nnp = p->nextSchedule->nextSchedule;
		delete p->nextSchedule;
		p->nextSchedule = nnp;
	}
}

FoodScheduleList* FoodSchedule::getFoodScheduleHeader() {
	return schedule;
}