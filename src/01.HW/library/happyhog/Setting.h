#ifndef __SETTING_H__
#define __SETTING_H__

/// @brief		Setting 클래스들의 추상클래스
/// @details	
/// @author		Jongho Lim, sloth@kookmin.ac.kr
/// @date		2016-02-11
/// @version	0.0.1

class Setting {
public:
	Setting();
	Setting(String& filePath, String& fileName);
	virtual ~Setting();
	
	virtual bool deserialize(String json) = 0;
	virtual String serialize() = 0;
	
	bool parseReversion(String json);	
	String getReversion();
	String getFilePath();
	String getFileName();

private:
	String filePath;
	String fileName;
	String reversion;
};

#endif