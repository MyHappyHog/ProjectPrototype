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
	// http request ����
	HTTPClient* http = new HTTPClient();
	
	// https download url ����
	http->begin(FPSTR(DOWNLOAD_URL), FPSTR(FINGER_PRINT));
	
	// Authorization ����� Auth Ű �Է�
	http->addHeader(FPSTR(AUTORIZATION), String("Bearer ") + key);
	
	// DROPBOX API ����� Argument �Է�
	String filePathName = data->getFilePath() + data->getFileName();

	String downloadArg = FPSTR(DOWNLOAD_ARG);
	downloadArg.replace(PATH_CONTENT_KEY, filePathName);

	http->addHeader(FPSTR(DROPBOX_API_ARG), downloadArg);
	
	// request ��û
	int httpCode = http->POST("");
	
	// response�� 200(OK)�� �ƴϸ� ����.
	/// @TODO invaild key �� �� ó���ϱ�. �� ����ó��..
	if(httpCode != 200) {
		delete http;
		return false;
	} 

	// response �����ͼ�
	// json �̿��� ���ڵ� ����
	String result = http->getString();
	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	// httpclient �޸� ��ȯ
	delete http;
	
	return data->deserialize(result);
}

bool H3Dropbox::upload(Setting* data) {
	// http request ����
	HTTPClient* http = new HTTPClient();
	
	// https upload url ����
	http->begin(FPSTR(UPLOAD_URL), FPSTR(FINGER_PRINT));

	// Authorization ����� Auth Ű �Է�
	http->addHeader(FPSTR(AUTORIZATION), String("Bearer ") + key);
	
	// DROPBOX API ����� Argument �Է�
	String filePathName = data->getFilePath() + data->getFileName();
	String uploadArg = FPSTR(UPLOAD_ARG);
	uploadArg.replace(PATH_CONTENT_KEY, filePathName);
	uploadArg.replace(REV_CONTENT_KEY, data->getReversion()); /// \TODO rev�������� ����

	http->addHeader(FPSTR(DROPBOX_API_ARG), uploadArg); 
	
	// Content-Type ��� �߰�
	http->addHeader(HEADER_CONTENT_TYPE, UPLOAD_TYPE_VALUE);
	
	// request ��û
	int httpCode = http->POST(data->serialize());
	
	// response�� 200(OK)�� �ƴϸ� ����.
	/// @TODO invaild key �� �� ó���ϱ�. �� ����ó��..
	if(httpCode != 200) {
		delete http;
		return false;
	} 

	// response �����ͼ�
	// json �̿��� ���ڵ� ����
	String result = http->getString();
	// httpclient �޸� ��ȯ
	delete http;

	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	/// @TODO rev Ȯ���ؼ� �����ϱ� �߰�.
	data->parseReversion(result);

	return true;
}