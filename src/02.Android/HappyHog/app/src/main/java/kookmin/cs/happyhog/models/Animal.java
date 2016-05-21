package kookmin.cs.happyhog.models;

public class Animal {
  private String name;
  private String description;
  private String imagePath;

  private SensingInformation sensingInformation;
  private DeviceInformation deviceInfomation;
  private RelayInformation relayInformation;
  private EnvironmentInformation environmentInformation;
  private FoodSchedules schedules;

  public Animal() {
    sensingInformation = new SensingInformation(0, 0);
    relayInformation = new RelayInformation(1, 2);
    environmentInformation = new EnvironmentInformation(25, 20, 70, 50);
    schedules = new FoodSchedules();
  }

  public Animal(String name, String description) {
    this();
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
  public FoodSchedules getSchedules() { return schedules; }

  public void setName(String name) { this.name = name; }
  public void setDescription(String description) { this.description = description; }
  public void setImagePath(String imagePath) { this.imagePath = imagePath; }

  public void setSensingInformation(SensingInformation sensingInformation) { this.sensingInformation = sensingInformation; }
  public void setDeviceInfomation(DeviceInformation deviceInfomation) { this.deviceInfomation = deviceInfomation; }
  public void setRelayInformation(RelayInformation relayInformation) {this.relayInformation = relayInformation; }
  public void setEnvironmentInformation(EnvironmentInformation environmentInformation) { this.environmentInformation = environmentInformation; }
  public void setSchedules(FoodSchedules schedules) { this.schedules = schedules; }
}