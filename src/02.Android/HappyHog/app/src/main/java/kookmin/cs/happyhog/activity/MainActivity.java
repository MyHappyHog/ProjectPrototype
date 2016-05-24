package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Picasso;

import java.io.File;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import butterknife.OnItemLongClick;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.H3Application;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.adapter.AnimalAdapter;
import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.dropbox.DropboxDownload;
import kookmin.cs.happyhog.dropbox.DropboxUpload;
import kookmin.cs.happyhog.dropbox.H3Dropbox;
import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.DeviceInformation;

// TODO 드랍박스 키 shared preference에 저장 및 불러오기 구현
// TODO 메인동물 이름 shared preference에 저장 및 불러오기 구현
// TODO 센서값 읽어오는 주기, 혹은 방법 생각해보기
public class MainActivity extends AppCompatActivity {

  @Bind(R.id.drawer_layout)
  DrawerLayout mDrawerLayout;

  @Bind(R.id.drawer)
  ListView mListview;

  @Bind(R.id.tv_main_title)
  TextView mTitleMain;

  @Bind(R.id.tv_main_memo)
  TextView mMemoMain;

  @Bind(R.id.tv_main_state)
  TextView mStateMain;

  @Bind(R.id.btn_video)
  ImageView mImageButton;

  private static final int CREATE_REQUEST_CODE = 1000;
  private static final int EDIT_REQUEST_CODE = 1001;
  private static final int DEALY_DOWNLOAD = 60 * 1000;

  private Handler mHandler = new Handler();

  private class DatabaseEventTask implements Runnable {

    public class Event {
      public static final int DB_INSERT = 0;
      public static final int DB_DELETE = 1;
      public static final int DB_UPDATE = 2;
    }

    private Animal animal;
    private int state;

    public DatabaseEventTask(Animal animal, int state) {
      this.animal = animal;
      this.state = state;
    }

    @Override
    public void run() {
      switch (state) {
        case Event.DB_INSERT:
          mAnimalAdapter.addItem(animal);
          break;

        case Event.DB_DELETE:
          mAnimalAdapter.removeItem(animal);
          break;

        case Event.DB_UPDATE:
          mAnimalAdapter.updateItem(animal);

          if (mainAnimalName.equals(animal.getName())) {
            updateMainAnimal(animal);
          }
          break;
      }
    }
  }

  private String mainAnimalName;
  private DatabaseManager mDatabaseManager;
  private AnimalAdapter mAnimalAdapter;
  private int selectedAnimal;

  private long lastDownloadTime = 0;

  @OnItemClick(R.id.drawer)
  public void registerMainAnimal(AdapterView<?> parent, View view, int position, long id) {
    selectedAnimal = position;
    AlertDialog.Builder dialog = new AlertDialog.Builder(this)
        .setTitle("[" + mAnimalAdapter.getAnimal(position).getName() + "] " + getResources().getText(R.string.main_register_main_animal));

    dialog.setPositiveButton(getResources().getText(R.string.dialog_ok), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        updateMainAnimal(mAnimalAdapter.getAnimal(selectedAnimal));
        mDrawerLayout.closeDrawers();

        dialog.dismiss();
      }
    });

    dialog.setNegativeButton(getResources().getText(R.string.dialog_cancle), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        dialog.cancel();
      }
    });

    dialog.show();
  }

  @OnItemLongClick(R.id.drawer)
  public boolean DeleteAnimal(AdapterView<?> parent, View view, int position, long id) {
    selectedAnimal = position;
    AlertDialog.Builder dialog = new AlertDialog.Builder(this)
        .setTitle("[" + mAnimalAdapter.getAnimal(position).getName() + "] " + getResources().getText(R.string.main_delete_animal));

    dialog.setPositiveButton(getResources().getText(R.string.dialog_ok), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        Animal animal = mAnimalAdapter.getAnimal(selectedAnimal);

        mDatabaseManager.delAnimal(animal);
        String imagePath = animal.getimagePath();
        if (!imagePath.equals("")) {
          File file = new File(imagePath);

          if (!file.delete()) {
            Toast.makeText(MainActivity.this, "이미지가 존재하지 않습니다.", Toast.LENGTH_SHORT).show();
          }
        }

        clearMainAnimal(animal);
        mDrawerLayout.closeDrawers();
        dialog.dismiss();
      }
    });

    dialog.setNegativeButton(getResources().getText(R.string.dialog_cancle), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        dialog.cancel();
      }
    });

    dialog.show();
    return true;
  }

  @OnClick(R.id.btn_feed)
  public void putFeedMainAnimal(View view) {
    Toast.makeText(this, "너에게 먹이를..", Toast.LENGTH_SHORT).show();
  }

  /**
   * 메인 동물의 세팅 액티비티를 호출하는 콜백 함수.
   */
  @OnClick(R.id.btn_animal_setting)
  public void openSettingActivity(View view) {
    if (mDatabaseManager.existsAnimal(mainAnimalName)) {
      Animal animal = mDatabaseManager.selectAnimal(mainAnimalName);
      Intent editIntent = new Intent(this, SettingActivity.class);
      editIntent.putExtra(Define.EXTRA_ANIMAL, animal);

      startActivityForResult(editIntent, EDIT_REQUEST_CODE);
    } else {
      Toast.makeText(this, getResources().getText(R.string.main_need_animal), Toast.LENGTH_SHORT).show();
    }
  }

  /**
   * 동물 리스트에서 동물을 추가하는 화면을 호출하는 콜백 함수.
   */
  @OnClick(R.id.fab)
  public void createAnimal(View view) {
    Intent createIntent = new Intent(this, ProfileActivity.class);
    createIntent.putExtra(Define.EXTRA_CREATE, true);
    createIntent.putExtra(Define.EXTRA_DEVICE_INFORMATION, new DeviceInformation());

    startActivityForResult(createIntent, CREATE_REQUEST_CODE);
  }

  @OnClick(R.id.btn_video)
  public void playStreaming(View view) {
    // TODO 유튜브 실시간 스트리밍 구현
    Toast.makeText(this, "비디오를 재생합니다.", Toast.LENGTH_SHORT).show();
  }

  private ActionBarDrawerToggle mDrawerToggle;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    ButterKnife.bind(this);

    mDatabaseManager = DatabaseManager.getInstance();

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    /**
     * 드로어 네비게이션 설정.
     */
    mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout, toolbar, R.string.app_name, R.string.app_name);
    mDrawerLayout.setDrawerListener(mDrawerToggle);

    Intent data = getIntent();
    if (data != null) {
      mainAnimalName = data.getStringExtra(Define.EXTRA_MAIN_NAME);
      lastDownloadTime = data.getLongExtra(Define.EXTRA_DOWNLOAD_TIME, 0);
    }

    /**
     * 동물 리스트 설정
     */
    mAnimalAdapter = new AnimalAdapter(this, mDatabaseManager.selectAllAnimals());
    mListview.setAdapter(mAnimalAdapter);

    mDatabaseManager.setOnUpdateDatabase(new DatabaseManager.OnUpdateDatabase() {
      @Override
      public void OnUpdate(Animal animal) {
        mHandler.post(new DatabaseEventTask(animal, DatabaseEventTask.Event.DB_UPDATE));
      }

      @Override
      public void OnInsert(Animal animal) {
        mHandler.post(new DatabaseEventTask(animal, DatabaseEventTask.Event.DB_INSERT));
      }

      @Override
      public void OnDelete(Animal animal) {
        mHandler.post(new DatabaseEventTask(animal, DatabaseEventTask.Event.DB_DELETE));
      }
    });

    /**
     * 메인 동물 표시
     */
    Animal mainAnimal = mDatabaseManager.selectAnimal(mainAnimalName);

    if (mainAnimal != null) {
      updateMainAnimal(mainAnimal);
    }
  }

  @Override
  protected void onPostCreate(Bundle savedInstanceState) {
    super.onPostCreate(savedInstanceState);

    mDrawerToggle.syncState();
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);

    mDrawerToggle.onConfigurationChanged(newConfig);
  }

  @Override
  public void onBackPressed() {
    if (mDrawerLayout.isDrawerOpen(GravityCompat.START)) {
      mDrawerLayout.closeDrawers();
      return;
    }

    super.onBackPressed();
  }

  @Override
  public void onResume() {
    super.onResume();

    /**
     * 동물 새로 만들었을 때 잠깐 인터넷 안되므로 동작 안함.
     */
    long currentTime = System.currentTimeMillis();
    if (currentTime - lastDownloadTime > DEALY_DOWNLOAD) {
      downloadSensingData();
    }
  }

  @Override
  public void onDestroy() {
    super.onDestroy();

    H3Dropbox h3Dropbox = H3Dropbox.getInstance();
    h3Dropbox.shutdownThreads();
    h3Dropbox.unlink();
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (resultCode == Activity.RESULT_OK) {
      Animal animal;

      switch (requestCode) {
        case CREATE_REQUEST_CODE:
          animal = new Animal(data.getStringExtra(Define.EXTRA_NAME), data.getStringExtra(Define.EXTRA_DESCRIPTION));
          animal.setImagePath(data.getStringExtra(Define.EXTRA_IMAGE_PATH));
          animal.setDeviceInfomation((DeviceInformation) data.getSerializableExtra(Define.EXTRA_DEVICE_INFORMATION));

          mDatabaseManager.addAnimal(animal);

          Toast.makeText(this, "[" + animal.getName() + "] " + getResources().getText(R.string.main_added_animal), Toast.LENGTH_SHORT).show();
          break;

        case EDIT_REQUEST_CODE:
          animal = (Animal) data.getSerializableExtra(Define.EXTRA_ANIMAL);

          if (animal.getName().equals(mainAnimalName)) {
            mDatabaseManager.updateAnimal(animal);
          } else {
            mDatabaseManager.delAnimal(mDatabaseManager.selectAnimal(mainAnimalName));
            mDatabaseManager.addAnimal(animal);
          }

          // TODO 각 셋팅창에서 나온 직후에 업로딩이 좋은지, 모두 수정 하고 난 뒤에 한꺼번에 하는 것이 좋은지 생각해보기
          DeviceInformation devInfo = animal.getDeviceInfomation();
          DropboxUpload environment = new DropboxUpload(devInfo.getSubMacAddress(), animal.getEnvironmentInformation());
          DropboxUpload relay = new DropboxUpload(devInfo.getSubMacAddress(), animal.getRelayInformation());
          DropboxUpload foodSchedule = new DropboxUpload(devInfo.getMainMacAddress(), animal.getSchedules());

          H3Dropbox h3Dropbox = H3Dropbox.getInstance();
          h3Dropbox.executeDropboxRequest(environment);
          h3Dropbox.executeDropboxRequest(relay);
          h3Dropbox.executeDropboxRequest(foodSchedule);

          updateMainAnimal(animal);
          break;
      }
    }
  }

  public void updateMainAnimal(Animal animal) {
    if (animal == null)
      return ;

    mainAnimalName = animal.getName();
    mTitleMain.setText(animal.getName());
    mMemoMain.setText(animal.getDescription());

    StringBuffer sb = new StringBuffer();
    sb.append("온도 : ").append(String.format(Locale.KOREA, "%.2f", animal.getSensingInformation().getTemperature()));
    sb.append(" 습도 : ").append(String.format(Locale.KOREA, "%.2f", animal.getSensingInformation().getHumidity()));
    mStateMain.setText(sb.toString());

    String imagePath = animal.getimagePath();
    if (!imagePath.equals("")) {
      File imageFile = new File(imagePath);
      Picasso.with(this).invalidate(imageFile);
      Picasso.with(this).load(imageFile)
          .fit()
          .into(mImageButton);
    } else {
      mImageButton.setImageDrawable(getResources().getDrawable(R.drawable.default_empty_image));
    }

    updateSharedPreference(Define.MAIN_ANIMAL_KEY, animal.getName());
  }

  public void clearMainAnimal(Animal animal) {
    if (!mainAnimalName.equals(animal.getName())) {
      return;
    }

    mainAnimalName = "";
    mTitleMain.setText("");
    mMemoMain.setText("");
    mStateMain.setText("");
    mImageButton.setImageDrawable(getResources().getDrawable(R.mipmap.ic_launcher));

    updateSharedPreference(Define.MAIN_ANIMAL_KEY, "");
  }

  public void downloadSensingData() {
    for (int i = 0; i < mAnimalAdapter.getCount(); i++) {
      Animal animal = mAnimalAdapter.getAnimal(i);

      DropboxDownload downloadSensing =
          new DropboxDownload(animal.getDeviceInfomation().getMainMacAddress(), animal.getName(), animal.getSensingInformation());

      H3Dropbox h3Dropbox = H3Dropbox.getInstance();
      h3Dropbox.executeDropboxRequest(downloadSensing);
    }
    lastDownloadTime = System.currentTimeMillis();
  }

  private void updateSharedPreference(String key, String value) {
    SharedPreferences.Editor editor = PreferenceManager.getDefaultSharedPreferences(H3Application.getmInstance()).edit();
    editor.putString(key, value);
    editor.apply();
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.action_settings:
        Intent intent = new Intent(this, InformationActivity.class);
        startActivity(intent);
        return true;
    }

    return super.onOptionsItemSelected(item);
  }
}