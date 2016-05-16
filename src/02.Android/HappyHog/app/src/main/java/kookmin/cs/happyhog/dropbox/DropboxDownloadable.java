package kookmin.cs.happyhog.dropbox;

public interface DropboxDownloadable {
  void takeDataFromJson(String json);
  String getFileName();
}