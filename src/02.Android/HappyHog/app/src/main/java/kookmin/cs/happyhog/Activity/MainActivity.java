package kookmin.cs.happyhog.Activity;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ListView;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.Adapter.AnimalAdapter;
import kookmin.cs.happyhog.R;

public class MainActivity extends AppCompatActivity {

  @Bind(R.id.drawer_layout)
  DrawerLayout mDrawerLayout;

  @Bind(R.id.drawer)
  ListView mListview;

  /**
   * 메인 동물의 세팅 액티비티를 호출하는 콜백 함수.
   * @param view
   */
  @OnClick(R.id.btn_animal_setting)
  public void openSettingActivity(View view) {
    startActivity(new Intent(this, SettingActivity.class));
  }

  /**
   * 동물 리스트에서 동물을 추가하는 화면을 호출하는 콜백 함수.
   * @param view
   */
  @OnClick(R.id.fab)
  public void createAnimal(View view) {
    startActivity(new Intent(this, ProfileActivity.class));
  }

  private ActionBarDrawerToggle mDrawerToggle;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    ButterKnife.bind(this);

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
    AnimalAdapter animalAdapter = new AnimalAdapter(this);
    mListview.setAdapter(animalAdapter);
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
      return ;
    }

    super.onBackPressed();
  }
}