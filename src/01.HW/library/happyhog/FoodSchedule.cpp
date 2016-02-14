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

	// json 스트링에 대괄호를 씌워서 배열로 만들어 줌.
	String jsonArray = "[C]";
	jsonArray.replace("C", json);

	// Array 파싱
	JsonArray& scheduleArray = jsonBuffer.parseArray(jsonArray);
	if (!scheduleArray.success()) {
		return false;
	}

	// 파싱한 Json Array를 데이터로 변환
	for (JsonArray::iterator it = scheduleArray.begin(); it != scheduleArray.end(); ++it) {
		JsonObject& obj = *it;
		addSchedule(obj[NUM_ROTATION_KEY], obj[TIME_KEY].asString());
	}

	return true;
}

String FoodSchedule::serialize() {
	// json array 생성
	DynamicJsonBuffer jsonBuffer;
	JsonArray& scheduleArray = jsonBuffer.createArray();

	// 모든 schedule 데이터를 json array로 변환
	FoodScheduleList* p = schedule;
	while (p != NULL) {
		// object 생성 및 데이터 변환
		JsonObject& node = jsonBuffer.createObject();
		node[NUM_ROTATION_KEY] = p->numRotation;
		node[TIME_KEY] = p->time;
		
		// object를 array에 추가
		scheduleArray.add(node);

		p = p->nextSchedule;
	}
	
	// json array를 스트링으로 변환
	String result;
	scheduleArray.printTo(result);

	// 변환된 스트링 반환
	return result;
};

void FoodSchedule::addSchedule(int numRotation, String time) {
	// 스케줄 리스트의 헤더가 없을 때
	if (schedule == NULL) {
		schedule = new FoodScheduleList;
		schedule->nextSchedule = NULL;
		schedule->numRotation = numRotation;
		schedule->time = time;
	} 
	// 헤더가 존재 할 때.
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
	
	// 제거할 노드가 헤더일 때
	if (schedule == delSchedule) {
		FoodScheduleList* np = schedule->nextSchedule;
		delete schedule;

		schedule = np;
	}
	// 헤더가 아닐 때
	// 노드를 찾아 제거하고 제거한 노드 앞 노드에 뒤 노드를 이어 줌.
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