package kookmin.cs.happyhog.dropbox;

import android.util.Log;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.DropboxAPI.DropboxFileInfo;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.exception.DropboxException;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;

import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.SensingInformation;

public class DropboxDownload implements Runnable {

  private String path;
  private String dbKey;
  private DropboxDownloadable downloadData;

  public DropboxDownload(String path, String dbKey, DropboxDownloadable downloadData) {
    this.path = path;
    this.dbKey = dbKey;
    this.downloadData = downloadData;
  }

  @Override
  public void run() {
    DropboxAPI<AndroidAuthSession> mApi = H3Dropbox.getInstance().getAPI();
    try {
      String dropboxPath = makeFilePath();
      List<DropboxAPI.Entry> revList = mApi.revisions(dropboxPath, 1);

      if (revList.size() == 0) {
        Log.d("mytag", "파일이 존재하지 않습니다");
        return ;
      }

      ByteArrayOutputStream baos = new ByteArrayOutputStream();

      // fileinfo 클래스가 필요할까?
      DropboxFileInfo fileinfo = mApi.getFile(dropboxPath, revList.get(0).rev, baos, null);
      downloadData.takeDataFromJson(new String(baos.toByteArray(), "UTF-8"));

      // 이거 수정해야되겠다..
      // 특히 타입캐스팅부분 고민해보기.
      DatabaseManager dm = DatabaseManager.getInstance();
      Animal animal = dm.selectAnimal(dbKey);
      animal.setSensingInformation((SensingInformation)downloadData);
      dm.updateAnimal(animal);

    } catch (DropboxException e) {
      e.printStackTrace();
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
  }

  private String makeFilePath() {
    return "/" + path + "/" + downloadData.getFileName();
  }
}
