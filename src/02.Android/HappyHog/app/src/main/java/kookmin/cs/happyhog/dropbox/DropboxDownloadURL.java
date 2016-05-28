package kookmin.cs.happyhog.dropbox;

import android.util.Log;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;

/**
 * Created by sloth on 2016-05-26.
 */
public class DropboxDownloadURL implements Runnable {
  public interface OnDownloadFileListener {
    public void onComplete(String fileContent);
  }

  private OnDownloadFileListener onDownloadFileListener;
  private String filePath;

  public DropboxDownloadURL(String macAddress) {
    filePath = macAddress;
  }

  @Override
  public void run() {
    DropboxAPI<AndroidAuthSession> mApi = H3Dropbox.getInstance().getAPI();
    try {
      String dropboxPath = filePath + "/happyhog.url";
      List<DropboxAPI.Entry> revList = mApi.revisions(dropboxPath, 1);

      if (revList.size() == 0) {
        Log.d("mytag", "파일이 존재하지 않습니다");
        return;
      }

      ByteArrayOutputStream baos = new ByteArrayOutputStream();

      // fileinfo 클래스가 필요할까?
      DropboxAPI.DropboxFileInfo fileinfo = mApi.getFile(dropboxPath, revList.get(0).rev, baos, null);

      if (onDownloadFileListener != null) {
        onDownloadFileListener.onComplete(new String(baos.toByteArray(), "UTF-8"));
      }
    } catch (DropboxException e) {
      e.printStackTrace();
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
  }

  public void setOnDownloadFileListener(OnDownloadFileListener onDownloadFileListener) {
    this.onDownloadFileListener = onDownloadFileListener;
  }
}
