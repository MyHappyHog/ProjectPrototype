package kookmin.cs.happyhog.wifi;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.IntentFilter;
import android.net.ConnectivityManager;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.widget.Toast;

import java.util.List;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.dropbox.DropboxUpload;
import kookmin.cs.happyhog.dropbox.H3Dropbox;
import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.DeviceInformation;

public class H3WiFiManager {
  private WiFiMonitor mWifiMonitor;
  private WifiManager mWifiManager;
  private Context mContext;

  private String mainMac;
  private String subMac;
  private String ssid;
  private String password;

  private ProgressDialog progressDialog;
  private OnCompleteAnimalListener onCompleteAnimalListener = null;

  private boolean firstRequest = true;
  private boolean complete = false;
  private boolean uploaded = false;

  public interface OnCompleteAnimalListener {

    public void onComplete();
  }

  public void setOnCompleteAnimalListener(OnCompleteAnimalListener onCompleteAnimalListener) {
    this.onCompleteAnimalListener = onCompleteAnimalListener;
  }

  public void setDeviceInfo(DeviceInformation devInfo, String password) {
    mainMac = devInfo.getMainMacAddress();
    subMac = devInfo.getSubMacAddress();
    ssid = devInfo.getSsid();
    this.password = password;
  }

  public H3WiFiManager(Context context) {
    ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
    mWifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
    mContext = context;

    mWifiMonitor = new WiFiMonitor(mWifiManager, mConnectivityManager);
    mWifiMonitor.setOnChangeNetworkStatusListener(new WiFiMonitor.OnChangeNetworkStatusListener() {
      @Override
      public void OnChanged(int status) {
        switch (status) {
          case WiFiMonitor.WIFI_STATE_ENABLED:
            startScan();
            break;

          case WiFiMonitor.COMPLETE_SEARCH:
            WifiConfiguration wfc;

            // main ESP 와 sub ESP가 존재하는지 확인.
            if (!isEnableEspAP()) {
              Toast.makeText(mContext, mContext.getText(R.string.progress_notexist), Toast.LENGTH_SHORT).show();
              progressDialog.dismiss();
            } else {
              progressDialog.setMessage(mContext.getText(R.string.progress_configure));
              wfc = configureWiFi();

              progressDialog.setMessage(mContext.getText(R.string.progress_connecting));
              connectEspAP(wfc);
            }
            break;

          case WiFiMonitor.NETWORK_STATE_CONNECTED:
            // WIFI에 연결 되었을 때
            // ESP 서버에 연결되었는지 확인하고
            // ESP 서버에 데이터 전송하기.
            sendPostRequest();
            break;

          case WiFiMonitor.NETWORK_STATE_DISCONNECTED:
            // 가능하면 기존의 설정되어 있던 와이파이 다시 재연결하기.
            break;

          case WiFiMonitor.NETWORK_STATE_CONNECTED_MOBILE:
            if (!uploaded && complete) {

              uploaded = true;
              uploadDefaultFiles();
            }
            break;
        }
      }
    });

    enableWiFi();
  }

  /**
   * 리시버 등록
   */
  public void registerReceiver() {
    mContext.registerReceiver(mWifiMonitor, new IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION));
    mContext.registerReceiver(mWifiMonitor, new IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION));
    mContext.registerReceiver(mWifiMonitor, new IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION));
  }

  /**
   * 등록된 리시버 해제
   */
  public void unRegisterReceiver() {
    if (mWifiMonitor != null) {
      mContext.unregisterReceiver(mWifiMonitor);
      mWifiMonitor = null;
    }
  }

  /**
   * WIFi를 켜는 함수, 이미 켜져 있다면 바로 스캔을 진행 함.
   */
  public void enableWiFi() {
    progressDialog =
        ProgressDialog
            .show(mContext, mContext.getResources().getString(R.string.app_name), mContext.getText(R.string.progress_enabling), true, false);

    mWifiManager.setWifiEnabled(false);
    mWifiManager.setWifiEnabled(true);
  }

  /**
   * 주변 WIFI 스캔하는 함수
   */
  public void startScan() {
    progressDialog.setMessage(mContext.getText(R.string.progress_searching));
    mWifiManager.startScan();
  }

  /**
   * 현재 ESP의 서버가 열려있는지 확인 함.
   */
  public boolean isEnableEspAP() {
    boolean main = false;
    boolean sub = false;
    List<ScanResult> wifiList = mWifiManager.getScanResults();
    for (ScanResult ap : wifiList) {

      if (ap.SSID.equals(mainMac)) {
        main = true;
      } else if (ap.SSID.equals(subMac)) {
        sub = true;
      }
    }

//    return main && sub;
    return main;
  }

  /**
   * 연결할 와이파이의 정보를 설정하여 설정된 정보를 반환함.
   */
  public WifiConfiguration configureWiFi() {
    String ssid = "\"".concat(mainMac).concat("\"");

    // 기존에 등록되어 있는 WIFI 정보들을 불러와
    // ESP WIFI가 기존에 등록 되어있는지 확인
    // 등록되어 있으면 등록된 설정 반환
    List<WifiConfiguration> wfcList = mWifiManager.getConfiguredNetworks();
    for (WifiConfiguration w : wfcList) {
      if (w.SSID.equals(ssid)) {
        return w;
      }
    }

    WifiConfiguration wfc = new WifiConfiguration();

    wfc.SSID = ssid;
    wfc.status = WifiConfiguration.Status.DISABLED;
    wfc.priority = 40;

    wfc.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN);
    wfc.allowedProtocols.set(WifiConfiguration.Protocol.RSN);
    wfc.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
    wfc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
    wfc.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
    wfc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
    wfc.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
    wfc.preSharedKey = "\"".concat("hog12345").concat("\"");

    return wfc;
  }

  /**
   * wfc에 들어있는 와이파이에 연결함. 등록되지 않은 와이파이면 등록하고 연결.
   */
  public void connectEspAP(WifiConfiguration wfc) {
    // 와이파이 설정 정보를 가져와
    // 현재 연결된 WIFI를 끊고 ESP의 WIFI에 연결
    int networkId = wfc.networkId;

    if (networkId == -1) {
      networkId = mWifiManager.addNetwork(wfc);
    }
    mWifiManager.enableNetwork(networkId, true);
  }

  /**
   * ESP서버에 세팅 정보를 담은 request 전송. ESP가 연결할 공유기의 ssid와 password, 온, 습도를 조절하는 ESP의 MAC address, 드랍박스 API를 사용할 Token을 전송 함.
   */
  public void sendPostRequest() {
    if (mWifiManager.getConnectionInfo().getSSID().equals("\"".concat(mainMac).concat("\""))) {
      if (firstRequest) {
        firstRequest = false;
        progressDialog.setMessage(mContext.getText(R.string.progress_esp_request));

        // POST request 만듦
        PostRequest request =
            new PostRequest(Define.ESP_SERVER_HOST, new String[]{ssid, password, subMac, H3Dropbox.getInstance().getAccessToken()});

        request.setOnCompleteResponseListener(new PostRequest.OnCompleteResponseListener() {
          @Override
          public void onResponse(String response) {
            // 연결했던 네트워크는 저장하지 않고 지움.
            mWifiManager.removeNetwork(mWifiManager.getConnectionInfo().getNetworkId());

            // 다이어로그를 닫고 ProfileActivity에 완료 이벤트를 보냄.
            if (onCompleteAnimalListener != null) {
              progressDialog.dismiss();
              complete = true;
              onCompleteAnimalListener.onComplete();
            }
          }
        });

        // POST request 보내기, 쓰레드 풀 이용
        H3Dropbox.getInstance().executeDropboxRequest(request);
      }
    }
  }

  /**
   * 드랍박스에 파일 업로드 main mac과 일치하는 ESP에는 FoodSchedule을 업로드 sub mac과 일치하는 ESP에는 Environment와 RelaySetting을 업로드
   *
   * 업로드는 쓰레드풀을 이용.
   */
  public void uploadDefaultFiles() {
    Animal animal = new Animal();
    DropboxUpload environment = new DropboxUpload(subMac, animal.getEnvironmentInformation());
    DropboxUpload relay = new DropboxUpload(subMac, animal.getRelayInformation());
    DropboxUpload foodSchedule = new DropboxUpload(mainMac, animal.getSchedules());

    H3Dropbox h3Dropbox = H3Dropbox.getInstance();
    h3Dropbox.executeDropboxRequest(environment);
    h3Dropbox.executeDropboxRequest(relay);
    h3Dropbox.executeDropboxRequest(foodSchedule);
  }
}
