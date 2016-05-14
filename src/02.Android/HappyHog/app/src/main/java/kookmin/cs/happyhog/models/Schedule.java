package kookmin.cs.happyhog.models;

public class Schedule {
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
}
