package kookmin.cs.happyhog.Activity;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.widget.ListView;

import butterknife.Bind;
import butterknife.ButterKnife;
import kookmin.cs.happyhog.Adapter.AnimalAdapter;
import kookmin.cs.happyhog.R;

public class MainActivity extends AppCompatActivity {

  @Bind(R.id.drawer_layout)
  DrawerLayout mDrawerLayout;

  @Bind(R.id.drawer)
  ListView mListview;

  private ActionBarDrawerToggle mDrawerToggle;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    ButterKnife.bind(this);

    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout, toolbar, R.string.app_name, R.string.app_name);
    mDrawerLayout.setDrawerListener(mDrawerToggle);

    AnimalAdapter animalAdapter = new AnimalAdapter(this);
    mListview.setAdapter(animalAdapter);

    /********************************************************************
     * 화면 전환용 테스트 코드
     * 몇 초마다 자동 화면 전환 됨.
     */
    Handler handler = new Handler();

    // onCreate가 호출되고 약 1초 뒤에 MainActivity로 화면 전환
    handler.postDelayed(new Runnable() {
      @Override
      public void run() {
        /*
          데이터 읽어오는 코드를 추가하기?, 초기 세팅
         */

        // MainActivity로 화면 전환
        //startActivity(new Intent(SplashActivity.this, MainActivity.class));
        startActivity(new Intent(MainActivity.this, SettingActivity.class));

        // SlashActivity 화면은 제거
        finish();
      }
    }, 5000);
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