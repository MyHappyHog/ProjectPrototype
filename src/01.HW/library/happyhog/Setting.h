#ifndef __SETTING_H__
#define __SETTING_H__

/// @brief		Setting 클래스들의 추상클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Setting {
public:
	Setting::Setting();
	virtual ~Setting();

	virtual String serialize() = 0;
	virtual int deserialize() = 0;
		
	String& getFilePath();
	String& getFileName();

protected:
	String filePath;
	String fileName;
};

#endif