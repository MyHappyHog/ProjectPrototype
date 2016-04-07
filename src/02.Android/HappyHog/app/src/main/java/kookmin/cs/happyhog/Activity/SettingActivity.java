package kookmin.cs.happyhog.Activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import butterknife.ButterKnife;
import kookmin.cs.happyhog.R;

/**
 * Created by sloth on 2016-04-07.
 */
public class SettingActivity extends AppCompatActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_setting);
    ButterKnife.bind(this);

    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar_setting);

    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

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
        startActivity(new Intent(SettingActivity.this, ProfileActivity.class));

        // SlashActivity 화면은 제거
        finish();
      }
    }, 3000);
  }
}
