package kookmin.cs.happyhog;

import android.app.Application;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

import kookmin.cs.happyhog.database.DatabaseManager;

public class H3Application extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    DatabaseManager.create(this);
    FacebookSdk.sdkInitialize(getApplicationContext());
    AppEventsLogger.activateApp(this);
  }
}