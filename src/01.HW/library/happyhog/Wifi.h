#ifndef __WIFI_H__
#define __WIFI_H__

#include "Setting.h"

#define SSID_KEY "ssid"
#define PASSWORD_KEY "password"
#define DROPBOX_ACCESS_KEY "boxkey"

#define WIFI_JSON_SIZE 200

typedef struct _WIFIData {
	String ssid;
	String password;
	String dropboxKey;
} WIFIData;

/// @brief		�������̿� ����ڽ��� ������ Ű ������ ��� �ִ� Ŭ����
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Wifi : public Setting {
public :
	Wifi(String fileName);
	Wifi(String filePath, String fileName);
	virtual ~Wifi();

	virtual int deserialize(String json);
	virtual String serialize();

private :
	WIFIData* data;
};


#endif