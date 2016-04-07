package kookmin.cs.happyhog.Activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import kookmin.cs.happyhog.R;

/**
 * Created by sloth on 2016-04-06.
 */
public class SplashActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_splash);

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
        startActivity(new Intent(SplashActivity.this, MainActivity.class));

        // SlashActivity 화면은 제거
        finish();
      }
    }, 3000);
  }
}
