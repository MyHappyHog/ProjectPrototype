#ifndef __DATASTORE_H__
#define __DATASTORE_H__

#include <Arduino.h>
#include "Setting.h"

/// @brief		HTTPS�� ESP�� FS�� ���� DataStore �߻�Ŭ����
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class DataStore {
public:
	DataStore() { };
	virtual ~DataStore() { };
	
	virtual String download(Setting* data, String key) = 0;
	virtual int upload(Setting* data, String key) = 0;
};

#endif