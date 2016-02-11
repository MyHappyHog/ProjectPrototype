#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#include "H3Dropbox.h"

H3Dropbox::H3Dropbox(String _key) : key(_key) {
	invaildKey = false;
}
H3Dropbox::~H3Dropbox() { }

bool H3Dropbox::download(Setting* data) {
	// http request ����
	HTTPClient* http = new HTTPClient();
	
	// https download url ����
	http->begin(DOWNLOAD_URL, CONTENT_FINGER_PRINT);
	
	// Authorization ����� Auth Ű �Է�
	http->addHeader(HEADER_AUTORIZATION, "Bearer " + key);
	
	// DROPBOX API ����� Argument �Է�
	String filePathName = data->getFilePath() + data->getFileName();
	String downloadArg = DOWNLOAD_ARGUMENT_TEMPLATE;
	downloadArg.replace(PATH_CONTENT_KEY, filePathName);
	http->addHeader(HEADER_DROPBOX_API_ARG, downloadArg);

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
	http->begin(UPLOAD_URL, CONTENT_FINGER_PRINT);
	
	// Authorization ����� Auth Ű �Է�
	http->addHeader(HEADER_AUTORIZATION, "Bearer " + key);
	
	// DROPBOX API ����� Argument �Է�
	String filePathName = data->getFilePath() + data->getFileName();
	String uploadArg = UPLOAD_ARGUMENT_TEMPLATE;
	uploadArg.replace(PATH_CONTENT_KEY, filePathName);
	uploadArg.replace(REV_CONTENT_KEY, "3e4404ddb9"); /// \TODO rev�������� ����
	http->addHeader(HEADER_DROPBOX_API_ARG, uploadArg); 
	
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
	result = result.substring(result.indexOf("{"), result.lastIndexOf("}") + 1);
	
	// httpclient �޸� ��ȯ
	delete http;

	/// @TODO rev Ȯ���ؼ� �����ϱ� �߰�.

	return true;
}