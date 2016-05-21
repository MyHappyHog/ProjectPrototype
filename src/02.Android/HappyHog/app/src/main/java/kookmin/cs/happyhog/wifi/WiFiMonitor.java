package kookmin.cs.happyhog.wifi;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiManager;

public class WiFiMonitor extends BroadcastReceiver {

  public final static int WIFI_STATE_ENABLED = 0x00;
  public final static int COMPLETE_SEARCH = WIFI_STATE_ENABLED + 1;

  public final static int NETWORK_STATE_CONNECTED = COMPLETE_SEARCH + 1;
  public final static int NETWORK_STATE_DISCONNECTED = NETWORK_STATE_CONNECTED + 1;
  public final static int NETWORK_STATE_CONNECTED_MOBILE = NETWORK_STATE_DISCONNECTED + 1;

  public interface OnChangeNetworkStatusListener {

    public void OnChanged(int status);
  }

  private WifiManager mWifiManager = null;
  private ConnectivityManager mConnManager = null;
  private OnChangeNetworkStatusListener mOnChangeNetworkStatusListener = null;

  public WiFiMonitor(WifiManager wifiManager, ConnectivityManager connectivityManager) {
    mWifiManager = wifiManager;
    mConnManager = connectivityManager;
  }

  public void setOnChangeNetworkStatusListener(OnChangeNetworkStatusListener listener) {
    mOnChangeNetworkStatusListener = listener;
  }

  @Override
  public void onReceive(Context context, Intent intent) {
    if (mOnChangeNetworkStatusListener == null) {
      return;
    }

    String action = intent.getAction();

    // 와이파이 상태 변경 이벤트
    if (action.equals(WifiManager.WIFI_STATE_CHANGED_ACTION) && mWifiManager.getWifiState() == WifiManager.WIFI_STATE_ENABLED) {
      mOnChangeNetworkStatusListener.OnChanged(WIFI_STATE_ENABLED);
    }
    // 와이파이 연결 상태 이벤트
    else if (action.equals(ConnectivityManager.CONNECTIVITY_ACTION)) {
      NetworkInfo networkInfo = mConnManager.getActiveNetworkInfo();
      if ((networkInfo != null) && (networkInfo.isAvailable())) {
        if (networkInfo.getType() == ConnectivityManager.TYPE_WIFI && networkInfo.isConnected()) {
          mOnChangeNetworkStatusListener.OnChanged(NETWORK_STATE_CONNECTED);
        } else if (networkInfo.getType() == ConnectivityManager.TYPE_MOBILE && networkInfo.isConnected()) {
          mOnChangeNetworkStatusListener.OnChanged(NETWORK_STATE_CONNECTED_MOBILE);
        }
      }
    }
    // 와이파이 스캔 이벤트
    else if (action.equals(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)) {
      mOnChangeNetworkStatusListener.OnChanged(COMPLETE_SEARCH);
    }
  }
}
