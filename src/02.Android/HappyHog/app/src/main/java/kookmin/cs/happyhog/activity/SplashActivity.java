package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.util.Log;
import android.widget.Toast;

import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.android.AuthActivity;
import com.dropbox.client2.session.AppKeyPair;

import java.io.File;
import java.util.ArrayList;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.dropbox.DropboxDownload;
import kookmin.cs.happyhog.dropbox.H3Dropbox;
import kookmin.cs.happyhog.models.Animal;

public class SplashActivity extends Activity {

  private static final int START_ACTIVITY_DELAY = 1000;
  private H3Dropbox h3Dropbox = H3Dropbox.getInstance();
  private boolean tryAuth = false;
  private String mainAnimalName;
  private long downloadTime;
  private boolean exit = false;

  private Handler mHandler = new Handler();

  private Runnable startMain = new Runnable() {
    @Override
    public void run() {
      if (!exit) {
        createFolderPath();
        DownloadSensingDataAll();

        // MainActivity로 화면 전환
        Intent intent = new Intent(SplashActivity.this, MainActivity.class);
        intent.putExtra(Define.EXTRA_MAIN_NAME, mainAnimalName);
        intent.putExtra(Define.EXTRA_DOWNLOAD_TIME, downloadTime);
        startActivity(intent);

        // SlashActivity 화면은 제거
        finish();
      }
    }
  };

  private Runnable startAuth = new Runnable() {
    @Override
    public void run() {
      if (!exit) {
        tryAuth = true;
        h3Dropbox.startOAuth2Authentication(SplashActivity.this);
      }
    }
  };

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_splash);
    checkAppKeySetup();

    SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(this);
    mainAnimalName = pref.getString(Define.MAIN_ANIMAL_KEY, "");
    boolean login = pref.getBoolean(Define.AUTO_LOGIN, false);
    String key = (login) ? pref.getString(Define.DROPBOX_KEY, "") : null;

    AndroidAuthSession session = buildSession(key);
    h3Dropbox.createDropboxApi(session);

    if (!h3Dropbox.getLoggedIn()) {
      mHandler.postDelayed(startAuth, START_ACTIVITY_DELAY);
    } else {
      mHandler.postDelayed(startMain, START_ACTIVITY_DELAY);
    }
  }

  @Override
  public void onResume() {
    super.onResume();

    // AuthAcitivity로 인증을 완료 했으면 메인 액티비티 호출
    // 아니면 AuthAcitivty를 호출하여 인증할 수 있도록 유도.
    if (h3Dropbox.authSuccessful()) {
      try {
        // Mandatory call to complete the auth
        h3Dropbox.finishAuth();

      } catch (IllegalStateException e) {
        Toast.makeText(this, "Couldn't authenticate with Dropbox:" + e.getLocalizedMessage(), Toast.LENGTH_SHORT).show();
        Log.i("logged in", "Error authenticating", e);
      }

      mHandler.postDelayed(startMain, START_ACTIVITY_DELAY);
    } else {
      if (tryAuth) {
        onBackPressed();
      }
    }
  }

  private AndroidAuthSession buildSession(String oldKey) {
    AppKeyPair appKeyPair = new AppKeyPair(Define.APP_KEY, Define.APP_SECRET);

    AndroidAuthSession session = new AndroidAuthSession(appKeyPair);

    if (oldKey != null && oldKey.length() != 0) {
      session.setOAuth2AccessToken(oldKey);
    }

    return session;
  }

  private void checkAppKeySetup() {

    // Check if the app has set up its manifest properly.
    Intent testIntent = new Intent(Intent.ACTION_VIEW);
    String scheme = "db-" + Define.APP_KEY;
    String uri = scheme + "://" + AuthActivity.AUTH_VERSION + "/test";
    testIntent.setData(Uri.parse(uri));
    PackageManager pm = getPackageManager();
    if (0 == pm.queryIntentActivities(testIntent, 0).size()) {
      Toast.makeText(this, "URL scheme in your app's " +
                           "manifest is not set up correctly. You should have a " +
                           "com.dropbox.client2.android.AuthActivity with the " +
                           "scheme: " + scheme, Toast.LENGTH_SHORT).show();
      onBackPressed();
    }
  }

  @Override
  public void onBackPressed() {
    exit = true;
    super.onBackPressed();
  }

  @Override
  public void onDestroy() {
    mHandler.removeCallbacks(startAuth);
    mHandler.removeCallbacks(startMain);
    if (exit) {
      h3Dropbox.shutdownThreads();
    }

    super.onDestroy();
  }

  private void DownloadSensingDataAll() {
    ArrayList<Animal> animals = DatabaseManager.getInstance().selectAllAnimals();

    for (Animal animal : animals) {
      DropboxDownload downloadSensing =
          new DropboxDownload(animal.getDeviceInfomation().getMainMacAddress(), animal.getName(), animal.getSensingInformation());

      h3Dropbox.executeDropboxRequest(downloadSensing);
    }

    downloadTime = System.currentTimeMillis();
  }

  private void createFolderPath() {
    String appFilePath = Environment.getExternalStorageDirectory().getAbsolutePath();
    String folderName = appFilePath + getResources().getString(R.string.image_folder);
    createDirectory(folderName);

    folderName = appFilePath + getResources().getString(R.string.screen_shot_folder);
    createDirectory(folderName);
  }

  private void createDirectory(String folderName) {
    File file = new File(folderName);

    if (!file.isDirectory()) {
      if (!file.mkdirs()) {
        Toast.makeText(this, "폴더 생성 실패", Toast.LENGTH_SHORT).show();
      }
    }
  }
}
