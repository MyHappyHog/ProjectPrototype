#ifndef __H3DROPBOX_H__
#define __H3DROPBOX_H__

#include "DataStore.h"

#define DOWNLOAD_URL "https://content.dropboxapi.com/2/files/download"
#define UPLOAD_URL "https://content.dropboxapi.com/2/files/upload"
#define CONTENT_FINGER_PRINT "E3 7F B0 09 DE E0 4E AB 3D 9D 44 F1 EC 38 64 C0 2B 85 90 12"

#define HEADER_AUTORIZATION "Authorization"
#define HEADER_CONTENT_TYPE "Content-Type"
#define UPLOAD_TYPE_VALUE "application/octet-stream"

#define HEADER_DROPBOX_API_ARG "Dropbox-API-Arg"

#define PATH_CONTENT_KEY "<filePathContent>"
#define REV_CONTENT_KEY "<revContent>"

#define DOWNLOAD_ARGUMENT_TEMPLATE "{\"path\": \"<filePathContent>\"}"
#define UPLOAD_ARGUMENT_TEMPLATE "{\"path\": \"<filePathContent>\", \"mode\":{\".tag\":\"update\",\"update\":\"<revContent>\"}}"

/// @brief		HTTPS�� �̿��� DROPBOX�� �����͸� �����ϰų� �������� Ŭ����
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class H3Dropbox : public DataStore {
public:
	H3Dropbox(String _key);
	virtual ~H3Dropbox();

	virtual int download(Setting* data);
	virtual int upload(Setting* data);
	
private:
	bool invaildKey;
	String key;
};

#endif