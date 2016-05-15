package kookmin.cs.happyhog.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.models.Schedule;

public class FeedingAdapter extends BaseAdapter{

  Context context;
  ArrayList<Schedule> schedules;

  public FeedingAdapter(Context context) {
    this.context = context;
  }

  public FeedingAdapter(Context context, ArrayList<Schedule> schedules) {
    this(context);

    this.schedules = schedules;

    if (schedules == null) {
      this.schedules = new ArrayList<>();
    }
  }

  public void addItem(Schedule schedule) {
    schedules.add(schedule);
    notifyDataSetChanged();
  }

  public void removeItem(int index) {
    schedules.remove(index);
    notifyDataSetChanged();
  }

  @Override
  public int getCount() {
    return schedules.size();
  }

  @Override
  public Object getItem(int position) {
    return schedules.get(position);
  }

  @Override
  public long getItemId(int position) {
    return position;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {

    if (convertView == null) {
      LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      convertView = inflater.inflate(R.layout.schedule_list_item, parent, false);
    }

    Schedule schedule = schedules.get(position);

    TextView scheduleView = (TextView) convertView.findViewById(R.id.tv_schedule_item);

    StringBuffer sb = new StringBuffer();
    sb.append(schedule.getNumRotate());
    sb.append(" CYCLE : (");

    int hour = schedule.getHour();
    if (hour < 12) {
      sb.append("AM)");
    } else {
      sb.append("PM)");
      hour -= 12;
    }

    if (hour == 0) hour += 12;
    if (hour < 10) sb.append(0);
    sb.append(hour);
    sb.append(":");

    int minute = schedule.getMinute();
    if (minute < 10) sb.append(0);
    sb.append(minute);

    scheduleView.setText(sb.toString());

    return convertView;
  }
}
