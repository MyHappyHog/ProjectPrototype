package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
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
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemLongClick;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.adapter.AnimalAdapter;
import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.dropbox.DropboxUpload;
import kookmin.cs.happyhog.dropbox.H3Dropbox;
import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.DeviceInformation;

// TODO 드랍박스 키 shared preference에 저장 및 불러오기 구현
// TODO 메인동물 이름 shared preference에 저장 및 불러오기 구현
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

  private static final int CREATE_REQUEST_CODE = 1000;
  private static final int EDIT_REQUEST_CODE = 1001;

  private String mainAnimalName = "";
  private DatabaseManager mDatabaseManager;
  private AnimalAdapter mAnimalAdapter;
  private int animalListFocus;

  @OnItemLongClick(R.id.drawer)
  public boolean registerMainAnimal(AdapterView<?> parent, View view, int position, long id) {
    animalListFocus = position;
    AlertDialog.Builder dialog = new AlertDialog.Builder(this)
        .setTitle("[" + mAnimalAdapter.getAnimal(position).getName() + "] " + getResources().getText(R.string.main_register_main_animal));

    dialog.setPositiveButton(getResources().getText(R.string.dialog_ok), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        updateMainAnimal(mAnimalAdapter.getAnimal(animalListFocus));
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

    /**
     * Test Code
     */
//    createIntent.putExtra(Define.EXTRA_NAME, "1");
//    createIntent.putExtra(Define.EXTRA_DESCRIPTION, "2");
//    DeviceInformation dev = new DeviceInformation("5ECF7F015442", "5ECF7F0153E9");
//    dev.setSsid("joh");
//    createIntent.putExtra(Define.EXTRA_DEVICE_INFORMATION, dev);

    startActivityForResult(createIntent, CREATE_REQUEST_CODE);
  }

  private ActionBarDrawerToggle mDrawerToggle;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    ButterKnife.bind(this);

    mDatabaseManager = DatabaseManager.getInstance();

    /**
     * Test Code
     */
//    Animal animal = new Animal("Name Test", "Description Test");
//    animal.setImagePath("myPath");
//    animal.setDeviceInfomation(new DeviceInformation("1AFE34F4B48D", "subMac"));
//    animal.setSensingInformation(new SensingInformation(10, 20));
//    animal.setEnvironmentInformation(new EnvironmentInformation(20 , 10, 40, 30));
//    animal.setRelayInformation(new RelayInformation(1, 2));
//    ArrayList<Schedule> schedules = new ArrayList<>();
//    schedules.add(new Schedule(1, 5, 0));
//    schedules.add(new Schedule(2, 23, 59));
//    animal.setSchedules(schedules);
//
//    List<Animal> list = mDatabaseManager.selectAllAnimals();
//    for (Animal animal : list) {
//      mDatabaseManager.delAnimal(animal);
//    }
//    mDatabaseManager.addAnimal(animal);

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

    /**
     * 동물 리스트 설정
     */
    mAnimalAdapter = new AnimalAdapter(this, (ArrayList<Animal>) mDatabaseManager.selectAllAnimals());
    mListview.setAdapter(mAnimalAdapter);

    /**
     * 메인 동물 표시
     */
    // TODO Main 동물 sharedPreference 에 저장된 것을 불러옴.
    Animal mainAnimal = mDatabaseManager.selectAnimal("123");

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
  public void onDestroy() {
    super.onDestroy();

    H3Dropbox.getInstance().shutdownThreads();
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == CREATE_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      Animal animal = new Animal(data.getStringExtra(Define.EXTRA_NAME), data.getStringExtra(Define.EXTRA_DESCRIPTION));
      animal.setDeviceInfomation((DeviceInformation) data.getSerializableExtra(Define.EXTRA_DEVICE_INFORMATION));

      mDatabaseManager.addAnimal(animal);
      mAnimalAdapter.addItem(animal);

      Toast.makeText(this, "[" + animal.getName() + "] " + getResources().getText(R.string.main_added_animal), Toast.LENGTH_SHORT).show();
    } else if (requestCode == EDIT_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      Animal animal = (Animal) data.getSerializableExtra(Define.EXTRA_ANIMAL);

      if (animal.getName().equals(mainAnimalName)) {
        mDatabaseManager.updateAnimal(animal);
      } else {
        mDatabaseManager.delAnimal(mainAnimalName);
        mDatabaseManager.addAnimal(animal);
      }

      mAnimalAdapter.updateItem(mainAnimalName, animal);

      // TODO 각 셋팅창에서 나온 직후에 업로딩이 좋은지, 모두 수정 하고 난 뒤에 한꺼번에 하는 것이 좋은지 생각해보기
      DeviceInformation devInfo = animal.getDeviceInfomation();
      DropboxUpload environment = new DropboxUpload(devInfo.getSubMacAddress(), animal.getEnvironmentInformation());
      DropboxUpload relay = new DropboxUpload(devInfo.getSubMacAddress(), animal.getRelayInformation());
      DropboxUpload foodSchedule = new DropboxUpload(devInfo.getMainMacAddress(), animal.getSchedules());

      H3Dropbox h3Dropbox = H3Dropbox.getInstance();
      h3Dropbox.executeDropboxRequest(environment);
      h3Dropbox.executeDropboxRequest(relay);
      h3Dropbox.executeDropboxRequest(foodSchedule);

      // TODO 업데이트 메인 화면.
      updateMainAnimal(animal);
    }
  }

  public void updateMainAnimal(Animal animal) {
    mainAnimalName = animal.getName();
    mTitleMain.setText(animal.getName());
    mMemoMain.setText(animal.getDescription());
    StringBuffer sb = new StringBuffer();
    sb.append("온도 : ").append(String.format(Locale.KOREA, "%.2f", animal.getSensingInformation().getTemperature()));
    sb.append(" 습도 : ").append(String.format(Locale.KOREA, "%.2f", animal.getSensingInformation().getHumidity()));
    mStateMain.setText(sb.toString());

    // TODO 사진 변경 추가
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