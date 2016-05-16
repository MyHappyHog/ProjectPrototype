package kookmin.cs.happyhog.models;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.dropbox.DropboxDownloadable;

public class SensingInformation implements Serializable, DropboxDownloadable {

  private double temperature;
  private double humidity;

  public SensingInformation(double temperature, double humidity) {
    this.temperature = temperature;
    this.humidity = humidity;
  }

  public double getTemperature() {
    return temperature;
  }

  public double getHumidity() {
    return humidity;
  }

  public void setTemperature(int temperature) {
    this.temperature = temperature;
  }

  public void setHumidity(int humidity) {
    this.humidity = humidity;
  }

  @Override
  public void takeDataFromJson(String json) {
    try {
      JSONObject jsonRoot = new JSONObject(json);
      temperature = jsonRoot.getDouble(Define.TEMPERATURE_KEY);
      humidity = jsonRoot.getDouble(Define.HUMIDITY_KEY);
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  @Override
  public String getFileName() {
    return "SensingInfo.json";
  }
}
