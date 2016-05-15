package kookmin.cs.happyhog.models;

import java.io.Serializable;

public class RelayInformation implements Serializable {

  private int warmer;
  private int humidifier;

  public RelayInformation(int warmer, int humidifier) {
    this.warmer = warmer;
    this.humidifier = humidifier;
  }

  public int getWarmer() {
    return warmer;
  }

  public int getHumidifier() {
    return humidifier;
  }

  public void setWarmer(int warmer) {
    this.warmer = warmer;
  }

  public void setHumidifier(int humidifier) {
    this.humidifier = humidifier;
  }
}
