package kookmin.cs.happyhog;

import android.app.Application;

import kookmin.cs.happyhog.database.DatabaseManager;

public class H3Application extends Application {

  private static H3Application mInstance;

  public static synchronized H3Application getmInstance() { return mInstance; }

  @Override
  public void onCreate() {
    super.onCreate();

    mInstance = this;

    DatabaseManager.create(this);
  }
}