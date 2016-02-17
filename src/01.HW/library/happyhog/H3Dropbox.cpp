#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include "H3Dropbox.h"

const char DOWNLOAD_ARG[] PROGMEM = DOWNLOAD_ARGUMENT_TEMPLATE;
const char UPLOAD_ARG[] PROGMEM = UPLOAD_ARGUMENT_TEMPLATE;
const char FINGER_PRINT[] PROGMEM = CONTENT_FINGER_PRINT;

const char DOWNLOAD_URL[] PROGMEM = DOWNLOAD_CONTENT_URL;
const char UPLOAD_URL[] PROGMEM = UPLOAD_CONTENT_URL;

const char AUTORIZATION[] PROGMEM = HEADER_AUTORIZATION;
const char DROPBOX_API_ARG[] PROGMEM = HEADER_DROPBOX_API_ARG;

H3Dropbox::H3Dropbox(String _key) : key(_key) {
	invaildKey = false;
}

H3Dropbox::~H3Dropbox() { 
}

bool H3Dropbox::download(Setting* data) {
	// http request 설정
	HTTPClient* http = new HTTPClient();
	
	// https download url 연결
	http->begin(FPSTR(DOWNLOAD_URL), FPSTR(FINGER_PRINT));
	
	// Authorization 헤더에 Auth 키 입력
	http->addHeader(FPSTR(AUTORIZATION), String("Bearer ") + key);
	
	// DROPBOX API 헤더에 Argument 입력
	String filePathName = data->getFilePath() + data->getFileName();

	String downloadArg = FPSTR(DOWNLOAD_ARG);
	downloadArg.replace(PATH_CONTENT_KEY, filePathName);

	http->addHeader(FPSTR(DROPBOX_API_ARG), downloadArg);
	
	// request 요청
	int httpCode = http->POST("");
	
	// response가 200(OK)이 아니면 종료.
	/// @TODO invaild key 일 때 처리하기. 즉 에러처리..
	if(httpCode != 200) {
		delete http;
		return false;
	} 

	// response 가져와서
	// json 이외의 문자들 제거
	String result = http->getString();
	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	// httpclient 메모리 반환
	delete http;
	
	return data->deserialize(result);
}

bool H3Dropbox::upload(Setting* data) {
	// http request 설정
	HTTPClient* http = new HTTPClient();
	
	// https upload url 연결
	http->begin(FPSTR(UPLOAD_URL), FPSTR(FINGER_PRINT));

	// Authorization 헤더에 Auth 키 입력
	http->addHeader(FPSTR(AUTORIZATION), String("Bearer ") + key);
	
	// DROPBOX API 헤더에 Argument 입력
	String filePathName = data->getFilePath() + data->getFileName();
	String uploadArg = FPSTR(UPLOAD_ARG);
	uploadArg.replace(PATH_CONTENT_KEY, filePathName);
	uploadArg.replace(REV_CONTENT_KEY, data->getReversion()); /// \TODO rev동적으로 변경

	http->addHeader(FPSTR(DROPBOX_API_ARG), uploadArg); 
	
	// Content-Type 헤더 추가
	http->addHeader(HEADER_CONTENT_TYPE, UPLOAD_TYPE_VALUE);
	
	// request 요청
	int httpCode = http->POST(data->serialize());
	
	// response가 200(OK)이 아니면 종료.
	/// @TODO invaild key 일 때 처리하기. 즉 에러처리..
	if(httpCode != 200) {
		delete http;
		return false;
	} 

	// response 가져와서
	// json 이외의 문자들 제거
	String result = http->getString();
	// httpclient 메모리 반환
	delete http;

	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	/// @TODO rev 확인해서 저장하기 추가.
	data->parseReversion(result);

	return true;
}