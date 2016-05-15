package kookmin.cs.happyhog.models;

import java.io.Serializable;

public class EnvironmentInformation implements Serializable {

  private int maxTemperature;
  private int minTemperature;
  private int maxHumidity;
  private int minHumidity;

  public EnvironmentInformation(int maxTemperature, int minTemperature, int maxHumidity, int minHumidity) {
    this.maxTemperature = maxTemperature;
    this.minTemperature = minTemperature;
    this.maxHumidity = maxHumidity;
    this.minHumidity = minHumidity;
  }

  public int getMaxTemperature() {
    return maxTemperature;
  }

  public int getMinTemperature() {
    return minTemperature;
  }

  public int getMaxHumidity() {
    return maxHumidity;
  }

  public int getMinHumidity() {
    return minHumidity;
  }

  public void setMaxTemperature(int maxTemperature) {
    this.maxTemperature = maxTemperature;
  }

  public void setMinTemperature(int minTemperature) {
    this.minTemperature = minTemperature;
  }

  public void setMaxHumidity(int maxHumidity) {
    this.maxHumidity = maxHumidity;
  }

  public void setMinHumidity(int minHumidity) {
    this.minHumidity = minHumidity;
  }
}
