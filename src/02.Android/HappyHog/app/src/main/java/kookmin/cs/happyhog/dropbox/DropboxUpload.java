package kookmin.cs.happyhog.dropbox;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.DropboxAPI.UploadRequest;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

public class DropboxUpload implements Runnable {

  private String path;
  private DropboxUploadable uploadData;
  private ArrayList<DropboxUploadable> uploadDatas;

  public DropboxUpload(String path, DropboxUploadable uploadData) {
    this.path = path;
    this.uploadData = uploadData;
  }

  public DropboxUpload(String path, ArrayList<DropboxUploadable> uploadDatas) {
    this.path = path;
    this.uploadDatas = uploadDatas;
  }

  @Override
  public void run() {
    DropboxAPI<AndroidAuthSession> mApi = H3Dropbox.getInstance().getAPI();
    String dropboxPath = makeFilePath();

    try {
      InputStream stream;

      if (uploadData != null) {
        stream = new ByteArrayInputStream(uploadData.toJson().getBytes("UTF-8"));
      } else {
        StringBuffer sb = new StringBuffer("[");
        for (DropboxUploadable uploadData : uploadDatas) {
          sb.append(uploadData.toJson());
          sb.append(",");
        }
        sb.setCharAt(sb.length() - 1, ']');

        stream = new ByteArrayInputStream(sb.toString().getBytes("UTF-8"));
      }

      UploadRequest request = mApi.putFileOverwriteRequest(dropboxPath, stream, stream.available(), null);

      if (request != null) {
        request.upload();
      }

    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    } catch (DropboxException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  private String makeFilePath() {
    if (uploadData != null) {
      return "/" + path + "/" + uploadData.getFileName();
    } else {
      return "/" + path + "/" + uploadDatas.get(0).getFileName();
    }
  }
}
