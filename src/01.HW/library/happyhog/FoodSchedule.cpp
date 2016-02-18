#include <Arduino.h>
#include <ArduinoJson.h>

#include "FoodSchedule.h"

FoodSchedule::FoodSchedule(String fileName) : FoodSchedule(String("/"), fileName) { }
FoodSchedule::FoodSchedule(String filePath, String fileName) : Setting(filePath, fileName) {
	schedule = nullptr;
}
FoodSchedule::~FoodSchedule() {
	while (schedule != nullptr) {
		removeSchedule(schedule);
	}
}

bool FoodSchedule::deserialize(String json, bool rev) {
	DynamicJsonBuffer jsonBuffer;
	
	// ������ ������ �ʱ�ȭ
	while (schedule != nullptr) {
		removeSchedule(schedule);
	}

	// �������� ������� �ٷ� ����.
	// json ��Ʈ���� ���ȣ�� ������ �迭�� ����� ��.
	if(json.equals("[]")) {
		return true;
	}
	else {
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
}

String FoodSchedule::serialize(bool rev) {
	// json array ����
	DynamicJsonBuffer jsonBuffer;
	JsonArray& scheduleArray = jsonBuffer.createArray();

	// ��� schedule �����͸� json array�� ��ȯ
	FoodScheduleList* p = schedule;
	while (p != nullptr) {
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
	if (schedule == nullptr) {
		schedule = new FoodScheduleList;
		schedule->nextSchedule = nullptr;
		schedule->numRotation = numRotation;
		schedule->time = time;
	} 
	// ����� ���� �� ��.
	else {
		FoodScheduleList* p = schedule;
		while ( p->nextSchedule != nullptr ) {
			p = p->nextSchedule;
		}

		p->nextSchedule = new FoodScheduleList;
		p->nextSchedule->nextSchedule = nullptr;
		p->nextSchedule->numRotation = numRotation;
		p->nextSchedule->time = time;
	}
}

void FoodSchedule::removeSchedule(FoodScheduleList* delSchedule) {
	if (schedule == nullptr || delSchedule == nullptr) {
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