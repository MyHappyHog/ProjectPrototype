package kookmin.cs.happyhog.models;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.util.ArrayList;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.dropbox.DropboxUploadable;

public class FoodSchedules implements Serializable, DropboxUploadable {

  private static final String FOOD_FILE_NAME = "FoodSchedule.json";
  private ArrayList<Schedule> schedules;

  public FoodSchedules() {
    schedules = new ArrayList<>();
  }

  public FoodSchedules(ArrayList<Schedule> schedules) {
    this.schedules = schedules;
  }

  public void addSchedule(Schedule schedule) {
    schedules.add(schedule);
  }

  public void removeSchedule(Schedule schedule) {
    schedules.remove(schedule);
  }

  public ArrayList<Schedule> getSchedules() { return schedules; }

  @Override
  public String toJson() {
    JSONArray jsonRoot = new JSONArray();
    try {
      for (Schedule schedule : schedules) {
        JSONObject object = new JSONObject();

        // 회전 횟수 입력
        object.put(Define.CYCLE_KEY, schedule.getNumRotate());

        // 먹이 줄 시간 입력
        StringBuffer sb = new StringBuffer();
        int hour = schedule.getHour();

        if (hour < 10) {
          sb.append("0");
        }
        sb.append(hour);
        sb.append(":");

        int minute = schedule.getMinute();
        if (minute < 10) {
          sb.append("0");
        }
        sb.append(minute);

        object.put(Define.TIME_KEY, sb.toString());
        jsonRoot.put(object);
      }
    } catch (JSONException e) {
      e.printStackTrace();
    }

    return jsonRoot.toString();
  }

  @Override
  public String getFileName() {
    return FOOD_FILE_NAME;
  }
}
