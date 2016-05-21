package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemLongClick;
import butterknife.OnItemSelected;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.adapter.FeedingAdapter;
import kookmin.cs.happyhog.models.FoodSchedules;
import kookmin.cs.happyhog.models.Schedule;

public class FeedingActivity extends AppCompatActivity {

  static ArrayList<String> hour;
  static ArrayList<String> minute;
  static ArrayList<String> meridiem;
  static ArrayList<Integer> cycle;

  static {
    hour = new ArrayList<>();
    minute = new ArrayList<>();
    meridiem = new ArrayList<>();
    cycle = new ArrayList<>();

    minute.add("00");
    for (int i = 1; i < 60; i++) {
      if (i <= 4) {
        cycle.add(i);
      }
      StringBuffer sb = new StringBuffer();
      if (i < 10)
        sb.append("0");
      sb.append(i);

      if (i <= 12) {
        hour.add(sb.toString());
      }

      minute.add(sb.toString());
    }

    meridiem.add("AM");
    meridiem.add("PM");
  }

  @Bind(R.id.spin_feeding_am_pm)
  Spinner ampmSpinner;
  @Bind(R.id.spin_feeding_hour)
  Spinner hourSpinner;
  @Bind(R.id.spin_feeding_minute)
  Spinner minuteSpinner;
  @Bind(R.id.spin_feeding_cycle)
  Spinner cycleSpinner;

  @Bind(R.id.feeding_listview)
  ListView mListView;

  @OnClick(R.id.fab_add_feeding)
  public void createSchedule(View view) {
    // 시간은 1시 ~ 12시까지 있음. 하지만 AM, PM 기준으로 12시가 가장 빠른 시간이므로
    // 12를 나눈 나머지를 취함. 따라서 0시 ~ 11시까지의 시간을 취할 수 있음.
    mCurrentHour %= 12;

    // 오후 시간일 때 12를 더함.
    if (mCurrentMeridiem.equals("PM"))
      mCurrentHour += 12;

    feedingAdapter.addItem(new Schedule(mCurrentCycle, mCurrentHour, mCurrentMinute));
    Toast.makeText(this, "" + mCurrentHour + ":" + mCurrentMinute, Toast.LENGTH_SHORT).show();
  }

  @OnItemLongClick(R.id.feeding_listview)
  public boolean deleteItem(AdapterView<?> parent, View view, int position, long id) {
    leastClickPosition = position;
    AlertDialog.Builder dialog = new AlertDialog.Builder(this)
        .setTitle(getResources().getText(R.string.feeding_ask_delete));

    dialog.setPositiveButton(getResources().getText(R.string.dialog_ok), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        feedingAdapter.removeItem(leastClickPosition);
        dialog.dismiss();
      }
    });

    dialog.setNegativeButton(getResources().getText(R.string.dialog_cancle), new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int which) {
        dialog.cancel();
      }
    });

    dialog.show();
    return true;
  }

  @OnItemSelected(R.id.spin_feeding_am_pm)
  public void selectAmPm(AdapterView<?> parent, View view, int position, long id) {
    mCurrentMeridiem = meridiem.get(position);
  }

  @OnItemSelected(R.id.spin_feeding_hour)
  public void selectHour(AdapterView<?> parent, View view, int position, long id) {
    mCurrentHour = Integer.parseInt(hour.get(position));
  }

  @OnItemSelected(R.id.spin_feeding_minute)
  public void selectMinute(AdapterView<?> parent, View view, int position, long id) {
    mCurrentMinute = Integer.parseInt(minute.get(position));
  }

  @OnItemSelected(R.id.spin_feeding_cycle)
  public void selectCycle(AdapterView<?> parent, View view, int position, long id) {
    mCurrentCycle = cycle.get(position);
  }

  private int mCurrentHour;
  private int mCurrentMinute;
  private int mCurrentCycle;
  private String mCurrentMeridiem;

  private FeedingAdapter feedingAdapter;
  private FoodSchedules schedules;
  private int leastClickPosition;

  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setContentView(R.layout.activity_feeding);
    ButterKnife.bind(this);

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    /**
     * 스피너 데이터 세팅
     */
    ArrayAdapter<String> stringAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, R.id.tv_spitem, meridiem);
    stringAdapter.setDropDownViewResource(R.layout.spinner_item);
    ampmSpinner.setAdapter(stringAdapter);

    stringAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, R.id.tv_spitem, hour);
    hourSpinner.setAdapter(stringAdapter);

    stringAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item, R.id.tv_spitem, minute);
    minuteSpinner.setAdapter(stringAdapter);

    ArrayAdapter<Integer> adapter = new ArrayAdapter<Integer>(this, R.layout.spinner_item, R.id.tv_spitem, cycle);
    adapter.setDropDownViewResource(R.layout.spinner_item);
    cycleSpinner.setAdapter(adapter);

    Intent data = getIntent();
    if (data != null) {
      schedules = (FoodSchedules) data.getSerializableExtra(Define.EXTRA_FOOD_SCHEDULES);
    }

    feedingAdapter = new FeedingAdapter(this, schedules.getSchedules());
    mListView.setAdapter(feedingAdapter);

    SimpleDateFormat sdf = new SimpleDateFormat("a:KK:mm", Locale.KOREA);
    String currentTime[] = sdf.format(new Date()).split(":");

    ampmSpinner.setSelection(meridiem.indexOf(currentTime[0]));
    hourSpinner.setSelection(hour.indexOf(currentTime[1]));
    minuteSpinner.setSelection(minute.indexOf(currentTime[2]));
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
    data.putExtra(Define.EXTRA_FOOD_SCHEDULES, schedules);
    setResult(Activity.RESULT_OK, data);
    super.onBackPressed();
  }
}
