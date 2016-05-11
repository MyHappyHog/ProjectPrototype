package kookmin.cs.happyhog.Activity;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import java.util.ArrayList;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnItemSelected;
import kookmin.cs.happyhog.R;

public class SensorActivity extends AppCompatActivity {

  private static ArrayList<Integer> mPickerNum = new ArrayList<>();
  private int minTemp = 20;
  private int maxTemp = 40;
  private int minHumid = 30;
  private int maxHumid = 60;

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
     * 초기 스피너 값 설정
     */
    minTempSpinner.setSelection(mPickerNum.indexOf(minTemp));
    maxTempSpinner.setSelection(mPickerNum.indexOf(maxTemp));
    minHumidSpinner.setSelection(mPickerNum.indexOf(minHumid));
    maxHumidSpinner.setSelection(mPickerNum.indexOf(maxHumid));
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
