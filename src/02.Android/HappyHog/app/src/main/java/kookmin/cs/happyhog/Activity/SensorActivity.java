package kookmin.cs.happyhog.Activity;

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
import kookmin.cs.happyhog.R;

public class SensorActivity extends AppCompatActivity {

  private static ArrayList<Integer> mPickerNum = new ArrayList<>();
  private static ArrayList<Boolean> mClickedTempRelay = new ArrayList<>(3);
  private static ArrayList<Boolean> mClickedHumidRelay = new ArrayList<>(3);

  // 임시 초기 값
  private int minTemp = 20;
  private int maxTemp = 40;
  private int minHumid = 30;
  private int maxHumid = 60;

  static {
    for (int i = 80; i >= 10; --i) {
      mPickerNum.add(i);
    }
    mClickedTempRelay.add(true);
    mClickedTempRelay.add(false);
    mClickedTempRelay.add(false);

    mClickedHumidRelay.add(false);
    mClickedHumidRelay.add(true);
    mClickedHumidRelay.add(false);
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
    setClickedTempRelay(0);
  }

  @OnClick(R.id.btn_sensor_temp_2)
  public void clickTemp2(View v) {
    setClickedTempRelay(1);
  }

  @OnClick(R.id.btn_sensor_temp_n)
  public void clickTempN(View v) {
    setClickedTempRelay(2);
  }

  @OnClick(R.id.btn_sensor_humid_1)
  public void clickHumid1(View v) {
    setClickedHumidRelay(0);
  }

  @OnClick(R.id.btn_sensor_humid_2)
  public void clickHumid2(View v) {
    setClickedHumidRelay(1);
  }

  @OnClick(R.id.btn_sensor_humid_n)
  public void clickHumidN(View v) {
    setClickedHumidRelay(2);
  }

  @OnItemSelected(R.id.spinner_min_temp)
  public void selectMinTempItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedTemp = mPickerNum.get(position);
    if (selectedTemp >= maxTemp) {
      minTempSpinner.setSelection(mPickerNum.indexOf(minTemp));
    } else {
      minTemp = selectedTemp;
    }
  }

  @OnItemSelected(R.id.spinner_max_temp)
  public void selectMaxTempItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedTemp = mPickerNum.get(position);
    if (selectedTemp <= minTemp) {
      maxTempSpinner.setSelection(mPickerNum.indexOf(maxTemp));
    } else {
      maxTemp = selectedTemp;
    }
  }

  @OnItemSelected(R.id.spinner_min_humid)
  public void selectMinHumidItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedHumid = mPickerNum.get(position);
    if (selectedHumid >= maxHumid) {
      minHumidSpinner.setSelection(mPickerNum.indexOf(minHumid));
    } else {
      minHumid = selectedHumid;
    }
  }

  @OnItemSelected(R.id.spinner_max_humid)
  public void selectMaxHumidItem(AdapterView<?> parent, View view, int position, long id) {
    int selectedHumid = mPickerNum.get(position);
    if (selectedHumid <= minHumid) {
      maxHumidSpinner.setSelection(mPickerNum.indexOf(maxHumid));
    } else {
      maxHumid = selectedHumid;
    }
  }

  private void setClickedTempRelay(int index) {
    if (mClickedTempRelay.get(index)) {
      return;
    }

    clearClickedTempButton();

    int currentTrueIndex = mClickedTempRelay.indexOf(true);
    mClickedTempRelay.set(currentTrueIndex, false);
    // 현재 상수를 파라미터로 넘겨받는 값으로 설정하기.
    mClickedTempRelay.set(index, true);

    switch (index) {
      case 0:
        buttonTemp1.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (mClickedHumidRelay.get(index)) clickHumid2(buttonHumid2);
        break;
      case 1:
        buttonTemp2.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (mClickedHumidRelay.get(index)) clickHumid1(buttonHumid1);
        break;
      default:
        buttonTempN.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        break;
    }
  }

  private void setClickedHumidRelay(int index) {
    // 이미 선택되어있을 때
    if (mClickedHumidRelay.get(index)) {
      return;
    }

    clearClickedHumidButton();
    int currentTrueIndex = mClickedHumidRelay.indexOf(true);
    mClickedHumidRelay.set(currentTrueIndex, false);
    // 현재 상수를 파라미터로 넘겨받는 값으로 설정하기.
    mClickedHumidRelay.set(index, true);

    switch (index) {
      case 0:
        buttonHumid1.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (mClickedTempRelay.get(index)) clickTemp2(buttonTemp2);
        break;
      case 1:
        buttonHumid2.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        if (mClickedTempRelay.get(index)) clickTemp1(buttonTemp1);
        break;
      default:
        buttonHumidN.setBackgroundColor(getResources().getColor(R.color.colorSplash));
        break;
    }
  }

  private void clearClickedTempButton() {
    buttonTemp1.setBackgroundColor(getResources().getColor(R.color.blank));
    buttonTemp2.setBackgroundColor(getResources().getColor(R.color.blank));
    buttonTempN.setBackgroundColor(getResources().getColor(R.color.blank));
  }

  private void clearClickedHumidButton() {
    buttonHumid1.setBackgroundColor(getResources().getColor(R.color.blank));
    buttonHumid2.setBackgroundColor(getResources().getColor(R.color.blank));
    buttonHumidN.setBackgroundColor(getResources().getColor(R.color.blank));
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_sensor);
    ButterKnife.bind(this);

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar_profile);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    /**
     * 온, 습도를 조절하는 스피너에 들어갈 어댑터
     */
    ArrayAdapter<Integer> adapter = new ArrayAdapter<Integer>(this, R.layout.spinner_item, R.id.tv_spitem, mPickerNum);
    adapter.setDropDownViewResource(R.layout.spinner_item);

    minTempSpinner.setAdapter(adapter);
    maxTempSpinner.setAdapter(adapter);
    minHumidSpinner.setAdapter(adapter);
    maxHumidSpinner.setAdapter(adapter);

    /**
     * 초기 값 설정
     */
    minTempSpinner.setSelection(mPickerNum.indexOf(minTemp));
    maxTempSpinner.setSelection(mPickerNum.indexOf(maxTemp));
    minHumidSpinner.setSelection(mPickerNum.indexOf(minHumid));
    maxHumidSpinner.setSelection(mPickerNum.indexOf(maxHumid));

    setClickedTempRelay(0);
    setClickedHumidRelay(1);
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
