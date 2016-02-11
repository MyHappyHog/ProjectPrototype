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
	
	virtual bool download(Setting* data) = 0;
	virtual bool upload(Setting* data) = 0;
};

#endif