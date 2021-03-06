#ifndef __WIFI_H__
#define __WIFI_H__

#include "Setting.h"

#define SSID_KEY "ssid"
#define PASSWORD_KEY "password"
#define DROPBOX_ACCESS_KEY "boxkey"
#define RELAY_MAC_KEY "relayMac"

#define DEFAULT_WIFI_FILENAME "/wifiInfo.json"

#define WIFI_JSON_SIZE 300

typedef struct _WIFIData {
	String ssid;
	String password;
	String dropboxKey;
	String relayMac;
} WIFIData;

/// @brief		와이파이와 드랍박스에 접근할 키 정보를 담고 있는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Wifi : public Setting {
public :
	Wifi(String fileName);
	Wifi(String filePath, String fileName);
	virtual ~Wifi();

	virtual bool deserialize(String json, bool rev = false);
	virtual String serialize(bool rev = false);

	String getSSID();
	String getPassword();
	String getDropboxKey();
	String getRelayMac();

	void setData(WIFIData* wifiData);

private :
	WIFIData* data;
};


#endif