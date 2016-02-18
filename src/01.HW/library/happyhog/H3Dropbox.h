#ifndef __H3DROPBOX_H__
#define __H3DROPBOX_H__

#include <ESP8266HTTPClient.h>
#include "DataStore.h"

#define DOWNLOAD_CONTENT_URL "https://content.dropboxapi.com/2/files/download"
#define UPLOAD_CONTENT_URL "https://content.dropboxapi.com/2/files/upload"
#define REVERSION_URL "https://api.dropboxapi.com/2/files/list_revisions"
#define LATEST_CURSOR_URL "https://api.dropboxapi.com/2/files/list_folder/get_latest_cursor"
#define LONGPOLL_URL "https://notify.dropboxapi.com/2/files/list_folder/longpoll"

#define CONTENT_FINGER_PRINT "E3 7F B0 09 DE E0 4E AB 3D 9D 44 F1 EC 38 64 C0 2B 85 90 12"
#define API_FINGER_PRINT "5b fb 74 b9 95 22 c2 59 20 d3 46 08 7f 8f d8 5e db 27 cb 00"

#define HEADER_AUTORIZATION "Authorization"
#define HEADER_CONTENT_TYPE "Content-Type"
#define UPLOAD_TYPE_VALUE "application/octet-stream"

#define HEADER_DROPBOX_API_ARG "Dropbox-API-Arg"

#define PATH_CONTENT_KEY "<filePathContent>"
#define REV_CONTENT_KEY "<revContent>"

#define DOWNLOAD_ARGUMENT_TEMPLATE "{\"path\": \"<filePathContent>\"}"
#define UPLOAD_ARGUMENT_TEMPLATE "{\"path\": \"<filePathContent>\", \"mode\":{\".tag\":\"update\",\"update\":\"<revContent>\"}}"

/// @brief		HTTPS를 이용해 DROPBOX에 데이터를 저장하거나 가져오는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class H3Dropbox : public DataStore {
public:
	H3Dropbox(String _key);
	virtual ~H3Dropbox();

	virtual bool download(Setting* data);
	virtual bool upload(Setting* data);
	bool reversions(Setting* data);
	bool requestLatestCursor(Setting* data);
	bool longPoll(Setting* data, int timeout);
	bool isChangeReversions(Setting* data);
	
private:
	void setAPIHeader(HTTPClient* http);
	bool invaildKey;
	String key;
};

#endif