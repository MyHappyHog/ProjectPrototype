#ifndef __H3FILESYSTEM_H__
#define __H3FILESYSTEM_H__

#include "DataStore.h"

/// @brief		ESP�� FS�� �̿��� DROPBOX�� �����͸� �����ϰų� �������� Ŭ����
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class H3FileSystem : public DataStore {
public:
	H3FileSystem();
	H3FileSystem(bool formatting);
	virtual ~H3FileSystem();

	virtual int download(Setting* data);
	virtual int upload(Setting* data);

private:
	bool spiffsReady;
};

#endif