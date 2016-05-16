package kookmin.cs.happyhog.dropbox;

import android.content.Context;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class H3Dropbox {

  private static final int THREAD_SIZE = 5;
  private DropboxAPI<AndroidAuthSession> mApi;
  private ExecutorService mThreadPool;

  private H3Dropbox() {
    mThreadPool = Executors.newFixedThreadPool(THREAD_SIZE);
  }

  private static class Singleton {

    private static final H3Dropbox instance = new H3Dropbox();
  }

  public static H3Dropbox getInstance() {
    return Singleton.instance;
  }

  public DropboxAPI<AndroidAuthSession> getAPI() {
    return mApi;
  }

  public void startOAuth2Authentication(Context context) {
    mApi.getSession().startOAuth2Authentication(context);
  }

  public boolean authSuccessful() {
    return mApi.getSession().authenticationSuccessful();
  }

  public void finishAuth() {
    mApi.getSession().finishAuthentication();
  }

  public String getAccessToken() {
    return mApi.getSession().getOAuth2AccessToken();
  }

  public boolean getLoggedIn() {
    return mApi.getSession().isLinked();
  }

  public void unlink() {
    mApi.getSession().unlink();
  }

  public void createDropboxApi(AndroidAuthSession session) {
    mApi = new DropboxAPI<AndroidAuthSession>(session);
    if (mThreadPool == null) {
      mThreadPool = Executors.newFixedThreadPool(THREAD_SIZE);
    }
  }

  public void executeDropboxRequest(Runnable runnable) {
    mThreadPool.execute(runnable);
  }

  public void shutdownThreads() {
    mThreadPool.shutdown();
    mThreadPool = null;
  }
}