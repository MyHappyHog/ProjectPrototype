package kookmin.cs.happyhog.Activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;

import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.R;

/**
 * Created by sloth on 2016-04-07.
 */
public class SettingActivity extends AppCompatActivity {

  /**
   * 프로필 버튼의 콜백 함수. 프로필 변경 액티비티 호출.
   * @param view
   */
  @OnClick(R.id.btn_setting_profile)
  public void openProfileActivity(View view) {
    startActivity(new Intent(this, ProfileActivity.class));
  }

  @OnClick(R.id.btn_setting_sensor)
  public void openSensorActivity(View view) { startActivity(new Intent(this, SensorActivity.class)); }

  @OnClick(R.id.btn_setting_feeding)
  public void openFeedingActivity(View view) { startActivity(new Intent(this, FeedingActivity.class)); }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_setting);
    ButterKnife.bind(this);

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);
  }

  /**
   * 툴바의 백(Back)키 콜백 함수
   */
  @Override
  public boolean onSupportNavigateUp() {
    onBackPressed();
    return true;
  }
}