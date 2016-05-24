package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

import java.io.File;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.EnvironmentInformation;
import kookmin.cs.happyhog.models.FoodSchedules;
import kookmin.cs.happyhog.models.RelayInformation;

public class SettingActivity extends AppCompatActivity {

  private static final int PROFILE_REQUEST_CODE = 2000;
  private static final int SENSOR_REQUEST_CODE = 2001;
  private static final int FEEDING_REQUEST_CODE = 2002;

  private Animal animal;

  @Bind(R.id.iv_setting_image)
  ImageView mAnimalImage;

  /**
   * 프로필 버튼의 콜백 함수. 프로필 변경 액티비티 호출.
   * @param view
   */
  @OnClick(R.id.btn_setting_profile)
  public void openProfileActivity(View view) {
    Intent editProfile = new Intent(this, ProfileActivity.class);
    editProfile.putExtra(Define.EXTRA_NAME, animal.getName());
    editProfile.putExtra(Define.EXTRA_DESCRIPTION, animal.getDescription());
    editProfile.putExtra(Define.EXTRA_IMAGE_PATH, animal.getimagePath());
    editProfile.putExtra(Define.EXTRA_DEVICE_INFORMATION, animal.getDeviceInfomation());

    startActivityForResult(editProfile, PROFILE_REQUEST_CODE);
  }

  @OnClick(R.id.btn_setting_sensor)
  public void openSensorActivity(View view) {
    Intent editSensor = new Intent(this, SensorActivity.class);
    editSensor.putExtra(Define.EXTRA_ENVIRONMENT_INFORMATION, animal.getEnvironmentInformation());
    editSensor.putExtra(Define.EXTRA_RELAY_INFORMATION, animal.getRelayInformation());

    startActivityForResult(editSensor, SENSOR_REQUEST_CODE);
  }

  @OnClick(R.id.btn_setting_feeding)
  public void openFeedingActivity(View view) {
    Intent editFeeding = new Intent(this, FeedingActivity.class);
    editFeeding.putExtra(Define.EXTRA_FOOD_SCHEDULES, animal.getSchedules());

    startActivityForResult(editFeeding, FEEDING_REQUEST_CODE);
  }

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

    Intent data = getIntent();
    if (data != null) {
      animal = (Animal) data.getSerializableExtra(Define.EXTRA_ANIMAL);
    }

    if (!animal.getimagePath().equals("")) {
      Picasso.with(this).load(new File(animal.getimagePath()))
          .fit()
          .into(mAnimalImage);
    }
  }

  @Override
  public void onDestroy() {
    Bitmap bitmap = ((BitmapDrawable) mAnimalImage.getDrawable()).getBitmap();
    bitmap.recycle();

    super.onDestroy();
  }
  /**
   * 툴바의 백(Back)키 콜백 함수
   */
  @Override
  public boolean onSupportNavigateUp() {
    onBackPressed();
    return true;
  }

  @Override
  public void onBackPressed() {
    Intent data = new Intent();
    data.putExtra(Define.EXTRA_ANIMAL, animal);
    setResult(Activity.RESULT_OK, data);
    super.onBackPressed();
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == PROFILE_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      animal.setName(data.getStringExtra(Define.EXTRA_NAME));
      animal.setDescription(data.getStringExtra(Define.EXTRA_DESCRIPTION));
      animal.setImagePath(data.getStringExtra(Define.EXTRA_IMAGE_PATH));

      if (!animal.getimagePath().equals("")) {
        File imageFile = new File(animal.getimagePath());
        Picasso.with(this).invalidate(imageFile);
        Picasso.with(this).load(imageFile)
            .fit()
            .into(mAnimalImage);
      }
    } else if (requestCode == SENSOR_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      animal.setEnvironmentInformation((EnvironmentInformation) data.getSerializableExtra(Define.EXTRA_ENVIRONMENT_INFORMATION));
      animal.setRelayInformation((RelayInformation) data.getSerializableExtra(Define.EXTRA_RELAY_INFORMATION));
    } else if (requestCode == FEEDING_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      animal.setSchedules((FoodSchedules) data.getSerializableExtra(Define.EXTRA_FOOD_SCHEDULES));
    }
  }
}