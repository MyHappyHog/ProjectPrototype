package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.adapter.AnimalAdapter;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.models.Animal;

public class MainActivity extends AppCompatActivity {

  @Bind(R.id.drawer_layout)
  DrawerLayout mDrawerLayout;

  @Bind(R.id.drawer)
  ListView mListview;

  private DatabaseManager mDatabaseManager;
  private AnimalAdapter mAnimalAdapter;

  /**
   * 메인 동물의 세팅 액티비티를 호출하는 콜백 함수.
   */
  @OnClick(R.id.btn_animal_setting)
  public void openSettingActivity(View view) {
    startActivity(new Intent(this, SettingActivity.class));
  }

  /**
   * 동물 리스트에서 동물을 추가하는 화면을 호출하는 콜백 함수.
   */
  @OnClick(R.id.fab)
  public void createAnimal(View view) {
    startActivityForResult(new Intent(this, ProfileActivity.class), 1000);
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
//    animal.setDeviceInfomation(new DeviceInformation("mainMac", "subMac"));
//    animal.setSensingInformation(new SensingInformation(10, 20));
//    animal.setEnvironmentInformation(new EnvironmentInformation(20 , 10, 40, 30));
//    animal.setRelayInformation(new RelayInformation(1, 2));
//    ArrayList<Schedule> schedules = new ArrayList<>();
//    schedules.add(new Schedule(1, 5, 0));
//    schedules.add(new Schedule(2, 23, 59));
//    animal.setSchedules(schedules);

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
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == 1000 && resultCode == Activity.RESULT_OK) {
//      Animal animal = new Animal();
//      animal.setName(data.getStringExtra("NAME"));
//      animal.setDescription(data.getStringExtra("DESCRIPTION"));
//      animal.setMacAdress(data.getStringExtra("MACADDRESS"));
//
//      mDatabaseManager.addAnimal(animal);
//      mAnimalAdapter.addItem(animal);
      Toast.makeText(this, "동물 만들어집니다", Toast.LENGTH_SHORT).show();
    }
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