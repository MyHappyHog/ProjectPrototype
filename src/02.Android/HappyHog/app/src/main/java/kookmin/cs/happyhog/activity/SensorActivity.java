package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemSelected;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.models.EnvironmentInformation;
import kookmin.cs.happyhog.models.RelayInformation;

public class SensorActivity extends AppCompatActivity {

  private static ArrayList<Integer> mPickerNum = new ArrayList<>();

  private EnvironmentInformation envInfo;
  private RelayInformation relayInfo;

  static {
    for (int i = 80; i >= 10; --i) {
      mPickerNum.add(i);
    }
  }

  @Bind(R.id.spinner_min_temp)
  Spinner minTempSpinner;

  @Bind(R.id.spinner_max_temp)
  Spinner maxTempSpinner;

  @Bind(R.id.spinner_min_humid)
  Spinner minHumidSpinner;

  @Bind(R.id.spinner_max_humid)
  Spinner maxHumidSpinner;

  @Bind(R.id.btn_sensor_temp_1)
  Button buttonTemp1;

  @Bind(R.id.btn_sensor_temp_2)
  Button buttonTemp2;

  @Bind(R.id.btn_sensor_temp_n)
  Button buttonTempN;

  @Bind(R.id.btn_sensor_humid_1)
  Button buttonHumid1;

  @Bind(R.id.btn_sensor_humid_2)
  Button buttonHumid2;

  @Bind(R.id.btn_sensor_humid_n)
  Button buttonHumidN;

  @OnClick(R.id.btn_sensor_temp_1)
  public void clickTemp1(View v) {
    setClickedTempRelay(1);
  }

  @OnClick(R.id.btn_sensor_temp_2)
  public void clickTemp2(View v) {
    setClickedTempRelay(2);
  }

  @OnClick(R.id.btn_sensor_temp_n)
  public void clickTempN(View v) {
    setClickedTempRelay(3);
  }

  @OnClick(R.id.btn_sensor_humid_1)
  public void clickHumid1(View v) {
    setClickedHumidRelay(1);
  }

  @OnClick(R.id.btn_sensor_humid_2)
  public void clickHumid2(View v) {
    setClickedHumidRelay(2);
  }

  @OnClick(R.id.btn_sensor_humid_n)
  public void clickHumidN(View v) {
    setClickedHumidRelay(3);
  }

  @OnItemSelected(R.id.spinner_min_temp)
  public void selectMinTempItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedTemp = mPickerNum.get(position);
    if (selectedTemp >= envInfo.getMaxTemperature()) {
      minTempSpinner.setSelection(mPickerNum.indexOf(envInfo.getMinTemperature()));
    } else {
      envInfo.setMinTemperature(selectedTemp);
    }
  }

  @OnItemSelected(R.id.spinner_max_temp)
  public void selectMaxTempItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedTemp = mPickerNum.get(position);
    if (selectedTemp <= envInfo.getMinTemperature()) {
      maxTempSpinner.setSelection(mPickerNum.indexOf(envInfo.getMaxTemperature()));
    } else {
      envInfo.setMaxTemperature(selectedTemp);
    }
  }

  @OnItemSelected(R.id.spinner_min_humid)
  public void selectMinHumidItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedHumid = mPickerNum.get(position);
    if (selectedHumid >= envInfo.getMaxHumidity()) {
      minHumidSpinner.setSelection(mPickerNum.indexOf(envInfo.getMinHumidity()));
    } else {
      envInfo.setMinHumidity(selectedHumid);
    }
  }

  @OnItemSelected(R.id.spinner_max_humid)
  public void selectMaxHumidItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedHumid = mPickerNum.get(position);
    if (selectedHumid <= envInfo.getMinHumidity()) {
      maxHumidSpinner.setSelection(mPickerNum.indexOf(envInfo.getMaxHumidity()));
    } else {
      envInfo.setMaxHumidity(selectedHumid);
    }
  }

  private void setClickedTempRelay(int index) {
    if (relayInfo.getWarmer() == index) {
      return;
    }

    clearClickedTempButton();

    // 현재 상수를 파라미터로 넘겨받는 값으로 설정하기.
    relayInfo.setWarmer(index);

    switch (index) {
      case 1:
        buttonTemp1.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (relayInfo.getHumidifier() == index) clickHumid2(buttonHumid2);
        break;
      case 2:
        buttonTemp2.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (relayInfo.getHumidifier() == index) clickHumid1(buttonHumid1);
        break;
      default:
        buttonTempN.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        break;
    }
  }

  private void setClickedHumidRelay(int index) {
    // 이미 선택되어있을 때
    if (relayInfo.getHumidifier() == index) {
      return;
    }

    clearClickedHumidButton();
    // 현재 상수를 파라미터로 넘겨받는 값으로 설정하기.
    relayInfo.setHumidifier(index);

    switch (index) {
      case 1:
        buttonHumid1.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (relayInfo.getWarmer() == index) clickTemp2(buttonTemp2);
        break;
      case 2:
        buttonHumid2.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (relayInfo.getWarmer() == index) clickTemp1(buttonTemp1);
        break;
      default:
        buttonHumidN.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        break;
    }
  }

  private void clearClickedTempButton() {
    buttonTemp1.setBackgroundColor(Color.WHITE);
    buttonTemp2.setBackgroundColor(Color.WHITE);
    buttonTempN.setBackgroundColor(Color.WHITE);
  }

  private void clearClickedHumidButton() {
    buttonHumid1.setBackgroundColor(Color.WHITE);
    buttonHumid2.setBackgroundColor(Color.WHITE);
    buttonHumidN.setBackgroundColor(Color.WHITE);
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_sensor);
    ButterKnife.bind(this);

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    /**
     * 온, 습도를 조절하는 스피너에 들어갈 어댑터
     */
    ArrayAdapter<Integer> adapter = new ArrayAdapter<Integer>(this, R.layout.sensor_spinner_item, R.id.tv_spitem, mPickerNum);
    adapter.setDropDownViewResource(R.layout.sensor_spinner_item);

    minTempSpinner.setAdapter(adapter);
    maxTempSpinner.setAdapter(adapter);
    minHumidSpinner.setAdapter(adapter);
    maxHumidSpinner.setAdapter(adapter);

    /**
     * 초기 값 설정
     */
    Intent data = getIntent();
    if (data != null) {
      envInfo = (EnvironmentInformation) data.getSerializableExtra(Define.EXTRA_ENVIRONMENT_INFORMATION);
      relayInfo = (RelayInformation) data.getSerializableExtra(Define.EXTRA_RELAY_INFORMATION);
    }
    minTempSpinner.setSelection(mPickerNum.indexOf(envInfo.getMinTemperature()));
    maxTempSpinner.setSelection(mPickerNum.indexOf(envInfo.getMaxTemperature()));
    minHumidSpinner.setSelection(mPickerNum.indexOf(envInfo.getMinHumidity()));
    maxHumidSpinner.setSelection(mPickerNum.indexOf(envInfo.getMaxHumidity()));

    setClickedTempRelay(relayInfo.getWarmer());
    setClickedHumidRelay(relayInfo.getHumidifier());
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
    data.putExtra(Define.EXTRA_ENVIRONMENT_INFORMATION, envInfo);
    data.putExtra(Define.EXTRA_RELAY_INFORMATION, relayInfo);
    setResult(Activity.RESULT_OK, data);
    super.onBackPressed();
  }
}
