#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#include "H3Dropbox.h"

H3Dropbox::H3Dropbox(String _key) : key(_key) {
	invaildKey = false;
}
H3Dropbox::~H3Dropbox() { }

bool H3Dropbox::download(Setting* data) {
	// http request 설정
	HTTPClient* http = new HTTPClient();
	
	// https download url 연결
	http->begin(DOWNLOAD_URL, CONTENT_FINGER_PRINT);
	
	// Authorization 헤더에 Auth 키 입력
	http->addHeader(HEADER_AUTORIZATION, "Bearer " + key);
	
	// DROPBOX API 헤더에 Argument 입력
	String filePathName = data->getFilePath() + data->getFileName();
	String downloadArg = DOWNLOAD_ARGUMENT_TEMPLATE;
	downloadArg.replace(PATH_CONTENT_KEY, filePathName);
	http->addHeader(HEADER_DROPBOX_API_ARG, downloadArg);

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
	http->begin(UPLOAD_URL, CONTENT_FINGER_PRINT);
	
	// Authorization 헤더에 Auth 키 입력
	http->addHeader(HEADER_AUTORIZATION, "Bearer " + key);
	
	// DROPBOX API 헤더에 Argument 입력
	String filePathName = data->getFilePath() + data->getFileName();
	String uploadArg = UPLOAD_ARGUMENT_TEMPLATE;
	uploadArg.replace(PATH_CONTENT_KEY, filePathName);
	uploadArg.replace(REV_CONTENT_KEY, "3e4404ddb9"); /// \TODO rev동적으로 변경
	http->addHeader(HEADER_DROPBOX_API_ARG, uploadArg); 
	
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
	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	// httpclient 메모리 반환
	delete http;

	/// @TODO rev 확인해서 저장하기 추가.

	return true;
}