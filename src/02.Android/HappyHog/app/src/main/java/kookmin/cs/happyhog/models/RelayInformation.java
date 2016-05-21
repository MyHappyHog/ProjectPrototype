package kookmin.cs.happyhog.models;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.dropbox.DropboxUploadable;

public class RelayInformation implements Serializable, DropboxUploadable {
  private static final String RELAY_FILE_NAME = "RelaySetting.json";
  private int warmer;
  private int humidifier;

  public RelayInformation() {
    this(1, 2);
  }

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

  @Override
  public String toJson() {
    JSONObject jsonRoot = new JSONObject();
    try {
      jsonRoot.put(Define.TEMPERATURE_KEY, warmer);
      jsonRoot.put(Define.HUMIDITY_KEY, humidifier);
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return jsonRoot.toString();
  }

  @Override
  public String getFileName() {
    return RELAY_FILE_NAME;
  }
}
