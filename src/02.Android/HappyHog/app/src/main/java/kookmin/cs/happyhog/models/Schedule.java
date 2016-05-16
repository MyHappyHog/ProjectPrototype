package kookmin.cs.happyhog.models;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.dropbox.DropboxUploadable;

public class Schedule implements Serializable, DropboxUploadable {
  private int mNumRotate;
  private int hour;
  private int minute;

  public Schedule(int numRotate, int hour, int minute) {
    mNumRotate = numRotate;
    this.hour = hour;
    this.minute = minute;
  }

  public void setNumRotate(int numRotate) { mNumRotate = numRotate; }
  public void setHour(int hour) { this.hour = hour; }
  public void setMinute(int minute) { this.minute = minute; }

  public int getNumRotate() { return mNumRotate; }
  public int getHour() { return hour; }
  public int getMinute() { return minute; }

  @Override
  public String toJson() {
    JSONObject jsonRoot = new JSONObject();
    try {
      jsonRoot.put(Define.CYCLE_KEY, mNumRotate);

      StringBuffer sb = new StringBuffer();
      if (hour < 10) sb.append("0");
      sb.append(hour);
      sb.append(":");
      if (minute < 10) sb.append("0");
      sb.append(minute);

      jsonRoot.put(Define.TIME_KEY, sb.toString());
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return jsonRoot.toString();
  }

  @Override
  public String getFileName() {
    return "FoodSchedule.json";
  }
}