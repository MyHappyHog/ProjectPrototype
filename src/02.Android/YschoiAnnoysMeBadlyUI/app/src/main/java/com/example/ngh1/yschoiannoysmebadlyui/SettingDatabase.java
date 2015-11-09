package com.example.ngh1.yschoiannoysmebadlyui;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/**
 * Created by ngh1 on 2015-09-21.
 */

public class SettingDatabase {
    private SharedPreferences pref;
    private SharedPreferences.Editor editer;

    public SettingDatabase(Context mContext) {
        pref = PreferenceManager.getDefaultSharedPreferences(mContext);
        editer = pref.edit();
    }

    public SettingDatabase(Context mContext, String prefName) {
        pref = mContext.getSharedPreferences(prefName, Context.MODE_PRIVATE);
        editer = pref.edit();
    }

    public boolean getBoolean(String key, boolean defValue) {
        return pref.getBoolean(key, defValue);
    }

    public int getInt(String key, int defValue) {
        return pref.getInt(key, defValue);
    }

    public String getString(String key, String defValue) {
        return pref.getString(key, defValue);
    }

    public void putBoolean(String key, boolean value) {
        editer.putBoolean(key, value).commit();
    }

    public void putInt(String key, int value) {
        editer.putInt(key, value).commit();
    }

    public void putString(String key, String value) {
        editer.putString(key, value).commit();
    }

    public void clear() {
        editer.clear().commit();
    }

    public void remove(String key) {
        editer.remove(key).commit();
    }
}