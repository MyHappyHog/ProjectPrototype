package kookmin.cs.happyhog.models;

import java.io.Serializable;

public class SensingInformation implements Serializable {

  private int temperature;
  private int humidity;

  public SensingInformation(int temperature, int humidity) {
    this.temperature = temperature;
    this.humidity = humidity;
  }

  public int getTemperature() {
    return temperature;
  }

  public int getHumidity() {
    return humidity;
  }

  public void setTemperature(int temperature) {
    this.temperature = temperature;
  }

  public void setHumidity(int humidity) {
    this.humidity = humidity;
  }
}
