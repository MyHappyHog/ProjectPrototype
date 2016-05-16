package kookmin.cs.happyhog.models;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.dropbox.DropboxUploadable;

public class EnvironmentInformation implements Serializable, DropboxUploadable {
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

  @Override
  public String toJson() {
    JSONObject jsonRoot = new JSONObject();
    try {
      JSONArray ja = new JSONArray();

      ja.put(maxTemperature).put(minTemperature);
      jsonRoot.put(Define.TEMPERATURE_KEY, ja);

      ja = new JSONArray();
      ja.put(maxHumidity).put(minHumidity);
      jsonRoot.put(Define.HUMIDITY_KEY, ja);
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return jsonRoot.toString();
  }

  @Override
  public String getFileName() {
    return "EnvironmentSetting.json";
  }
}
