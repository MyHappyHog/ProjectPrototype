package kookmin.cs.happyhog.wifi;

import java.io.IOException;

import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class PostRequest implements Runnable {
  private static final String ARG_NAME_SSID = "ssid";
  private static final String ARG_NAME_PASSWORD = "password";
  private static final String ARG_NAME_RELAY_MAC = "relayMac";
  private static final String ARG_NAME_DROPBOX_KEY = "dropboxKey";

  private String url;
  private String params[];

  OkHttpClient client = new OkHttpClient();

  public PostRequest(String url, String params[]) {
    this.url = url;
    this.params = params;
  }

  @Override
  public void run() {
    RequestBody formBody = new FormBody.Builder()
        .add(ARG_NAME_SSID, params[0])
        .add(ARG_NAME_PASSWORD, params[1])
        .add(ARG_NAME_RELAY_MAC, params[2])
        .add(ARG_NAME_DROPBOX_KEY, params[3])
        .build();
    Request request = new Request.Builder()
        .url(url)
        .post(formBody)
        .build();
    try {
      Response response = client.newCall(request).execute();
      if (mOnCompleteResponseListener != null) {
        mOnCompleteResponseListener.onResponse(response.body().string());
      }
    } catch (IOException e) {
      e.printStackTrace();
      if (mOnCompleteResponseListener != null) {
        mOnCompleteResponseListener.onResponse("에러났다부러");
      }
    }

  }

  public interface OnCompleteResponseListener {
    void onResponse(String response);
  }

  private OnCompleteResponseListener mOnCompleteResponseListener = null;

  public void setOnCompleteResponseListener(OnCompleteResponseListener listener) {
    mOnCompleteResponseListener = listener;
  }
}
