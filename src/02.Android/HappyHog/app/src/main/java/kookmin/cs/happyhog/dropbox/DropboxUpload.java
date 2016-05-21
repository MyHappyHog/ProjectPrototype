package kookmin.cs.happyhog.dropbox;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.DropboxAPI.UploadRequest;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

public class DropboxUpload implements Runnable {

  private String path;
  private DropboxUploadable uploadData;

  public DropboxUpload(String path, DropboxUploadable uploadData) {
    this.path = path;
    this.uploadData = uploadData;
  }

  @Override
  public void run() {
    DropboxAPI<AndroidAuthSession> mApi = H3Dropbox.getInstance().getAPI();
    String dropboxPath = makeFilePath();

    try {
      InputStream stream = new ByteArrayInputStream(uploadData.toJson().getBytes("UTF-8"));
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
    return "/" + path + "/" + uploadData.getFileName();
  }
}
