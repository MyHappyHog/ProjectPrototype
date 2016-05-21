package kookmin.cs.happyhog.models;

import java.io.Serializable;

public class DeviceInformation implements Serializable {

  private String ssid;
  private String mainMacAddress;
  private String subMacAddress;

  public DeviceInformation(String mainMacAddress, String subMacAddress) {
    this.mainMacAddress = mainMacAddress;
    this.subMacAddress = subMacAddress;
    ssid = "";
  }

  public String getMainMacAddress() {
    return mainMacAddress;
  }

  public String getSubMacAddress() {
    return subMacAddress;
  }

  public String getSsid() {
    return ssid;
  }

  public void setMainMacAdress(String mainMacAddress) {
    this.mainMacAddress = mainMacAddress;
  }

  public void setSubMacAddress(String subMacAddress) {
    this.subMacAddress = subMacAddress;
  }

  public void setSsid(String ssid) {
    this.ssid = ssid;
  }
}
