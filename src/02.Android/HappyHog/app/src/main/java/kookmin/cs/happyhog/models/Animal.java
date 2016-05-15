package kookmin.cs.happyhog.models;

import java.util.ArrayList;

public class Animal {
  private String name;
  private String description;
  private String imagePath;

  private SensingInformation sensingInformation;
  private DeviceInformation deviceInfomation;
  private RelayInformation relayInformation;
  private EnvironmentInformation environmentInformation;
  private ArrayList<Schedule> schedules;

  public Animal(String name, String description) {
    this.name = name;
    this.description = description;
  }

  public String getName() { return name; }
  public String getDescription() { return description; }
  public String getimagePath() { return imagePath; }

  public SensingInformation getSensingInformation() { return sensingInformation; }
  public DeviceInformation getDeviceInfomation() { return deviceInfomation; }
  public RelayInformation getRelayInformation() { return relayInformation; }
  public EnvironmentInformation getEnvironmentInformation() { return environmentInformation; }
  public ArrayList<Schedule> getSchedules() { return schedules; }

  public void setName(String name) { this.name = name; }
  public void setDescription(String description) { this.description = description; }
  public void setImagePath(String imagePath) { this.imagePath = imagePath; }

  public void setSensingInformation(SensingInformation sensingInformation) { this.sensingInformation = sensingInformation; }
  public void setDeviceInfomation(DeviceInformation deviceInfomation) { this.deviceInfomation = deviceInfomation; }
  public void setRelayInformation(RelayInformation relayInformation) {this.relayInformation = relayInformation; }
  public void setEnvironmentInformation(EnvironmentInformation environmentInformation) { this.environmentInformation = environmentInformation; }
  public void setSchedules(ArrayList<Schedule> schedules) { this.schedules = schedules; }
}