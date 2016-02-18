#ifndef __H3FILESYSTEM_H__
#define __H3FILESYSTEM_H__

#include "DataStore.h"

/// @brief		ESP의 FS를 이용해 DROPBOX에 데이터를 저장하거나 가져오는 클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class H3FileSystem : public DataStore {
public:
	H3FileSystem();
	H3FileSystem(bool formatting);
	virtual ~H3FileSystem();

	virtual bool download(Setting* data);
	virtual bool upload(Setting* data);

private:
	bool spiffsReady;
};

#endif