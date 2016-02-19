#include <ESP8266WiFi.h>
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

		Serial.print("httpCode : ");
		Serial.println(httpCode);
		Serial.println(ESP.getFreeHeap());
		if (httpCode == 409 && reversions(data)) {
			return upload(data);
		}
		return false;
	} 

	// response �����ͼ�
	// json �̿��� ���ڵ� ����
	String result = http->getString();
	// httpclient �޸� ��ȯ
	delete http;

	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);

	/// @TODO rev Ȯ���ؼ� �����ϱ� �߰�.
	if (!data->parseReversion(result)) {
		return false;
	}

	return requestLatestCursor(data);
}

void H3Dropbox::setAPIHeader(HTTPClient* http) {	
	// Authorization ����� Auth Ű �Է�
	http->addHeader(FPSTR(AUTORIZATION), String("Bearer ") + key);

	// Content-Type ��� �߰�
	http->addHeader(HEADER_CONTENT_TYPE, "application/json");
}

bool H3Dropbox::reversions(Setting* data) {
	// http request ����
	HTTPClient* http = new HTTPClient();

	// https reversions url ����
	http->begin(REVERSION_URL, API_FINGER_PRINT);
	setAPIHeader(http);

	// request ��û
	int httpCode = http->POST(String("{\"path\":\"" + data->getFilePath() + data->getFileName() + "\", \"limit\":1}"));

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

	int firstIndex = result.indexOf("{");
	int lastIndex = result.lastIndexOf("}");

	result = result.substring(result.indexOf("{", firstIndex + 1), result.lastIndexOf("}", lastIndex - 1) + 1);

	/// @TODO rev Ȯ���ؼ� �����ϱ� �߰�.
	return data->parseReversion(result);
}

bool H3Dropbox::requestLatestCursor(Setting* data) {
	// http request ����
	HTTPClient* http = new HTTPClient();

	// https reversions url ����
	http->begin(LATEST_CURSOR_URL, API_FINGER_PRINT);
	setAPIHeader(http);

	// request ��û
	int httpCode = http->POST(String("{\"path\":\"" + data->getFilePath() + "\"}"));

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
	return data->parseCursor(result);
}

bool H3Dropbox::longPoll(Setting* data, int timeout) {
	// http request ����
	HTTPClient* http = new HTTPClient();

	// https reversions url ����
	http->begin(LONGPOLL_URL, API_FINGER_PRINT);

	// Content-Type ��� �߰�
	http->addHeader(HEADER_CONTENT_TYPE, "application/json");

	// request ��û
	int httpCode = http->POST(String("{\"cursor\":\"" + data->getCurrentCursor() + "\", \"timeout\":" + timeout + "}"));
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
	if(result.indexOf("true") != -1) {
		return true;
	}

	return false;
}

bool H3Dropbox::isChangeReversions(Setting* data) {
	String oldRev = data->getReversion();

	// rev�� ���� �޾Ƽ� ���� �������� ��
	if (reversions(data) && !oldRev.equalsIgnoreCase(data->getReversion())) {
		return true;
	}

	return false;
}