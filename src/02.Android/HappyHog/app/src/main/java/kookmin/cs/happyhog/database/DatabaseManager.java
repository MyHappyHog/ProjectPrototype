package kookmin.cs.happyhog.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;

import kookmin.cs.happyhog.models.Animal;
import kookmin.cs.happyhog.models.DeviceInformation;
import kookmin.cs.happyhog.models.EnvironmentInformation;
import kookmin.cs.happyhog.models.FoodSchedules;
import kookmin.cs.happyhog.models.RelayInformation;
import kookmin.cs.happyhog.models.SensingInformation;

/**
 * DB를 조작하는 클래스. 싱글톤 패턴 적용. 최초 H3Application 함수에서 create로 인스턴스화하고 getInstance 함수로 인스턴스를 얻을 수 있다.
 */
public class DatabaseManager extends SQLiteOpenHelper {

  private static final String DB_NAME = "HAPPYHOG";
  private static final int DB_VERSION = 2;

  private static final String TYPE_TEXT = " TEXT";
  private static final String TYPE_BLOB = " BLOB";
  private static final String PRIMARY_KEY = " PRIMARY KEY";
  private static final String COMMA_SEP = ",";

  private static final String TABLE_HAPPYHOG = "HAPPYHOG_Animal";
  private static final String NAME = "name";
  private static final String DESCRIPTION = "description";
  private static final String IMAGE_PATH = "image_path";
  private static final String DEVICE_INFORMATION = "device";
  private static final String SENSING_INFORMATION = "sensing";
  private static final String ENVIRONMENT_INFORMATION = "environment";
  private static final String RELAY_INFORMATION = "relay";
  private static final String SCHEDULE_INFORMATION = "schedule";

  public interface OnUpdateDatabase {

    public void OnUpdate(Animal animal);
    public void OnInsert(Animal animal);
    public void OnDelete(Animal animal);
  }

  private OnUpdateDatabase onUpdateDatabase;

  public void setOnUpdateDatabase(OnUpdateDatabase onUpdateDatabase) {
    this.onUpdateDatabase = onUpdateDatabase;
  }

  private static final String CREATE_TABLE =
      "CREATE TABLE " + TABLE_HAPPYHOG + "(" +
      NAME + TYPE_TEXT + PRIMARY_KEY + COMMA_SEP +
      DESCRIPTION + TYPE_TEXT + COMMA_SEP +
      IMAGE_PATH + TYPE_TEXT + COMMA_SEP +
      DEVICE_INFORMATION + TYPE_BLOB + COMMA_SEP +
      SENSING_INFORMATION + TYPE_BLOB + COMMA_SEP +
      ENVIRONMENT_INFORMATION + TYPE_BLOB + COMMA_SEP +
      RELAY_INFORMATION + TYPE_BLOB + COMMA_SEP +
      SCHEDULE_INFORMATION + TYPE_BLOB + ")";

  private static final String DELETE_TABLE =
      "DROP TABLE IF EXISTS " + TABLE_HAPPYHOG;

  private static DatabaseManager mDatabaseManager;

  private DatabaseManager(Context context) {
    super(context, DB_NAME, null, DB_VERSION);
  }

  public static void create(Context context) {
    if (mDatabaseManager == null) {
      mDatabaseManager = new DatabaseManager(context);
    }
  }

  public static DatabaseManager getInstance() {
    return mDatabaseManager;
  }

  /**
   * 콜백함수로 DB를 생성하는 함수
   */
  @Override
  public void onCreate(SQLiteDatabase db) {
    db.execSQL(CREATE_TABLE);
  }

  @Override
  public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    db.execSQL(DELETE_TABLE);
    onCreate(db);
  }

  /**
   * 해당 animal 정보를 DB에 저장하는 함수
   */
  public void addAnimal(Animal animal) {
    if (existsAnimal(animal.getName())) {
      return;
    }

    ContentValues values = makeContentValue(animal);

    getWritableDatabase().insert(TABLE_HAPPYHOG, null, values);

    if (onUpdateDatabase != null) {
      onUpdateDatabase.OnInsert(animal);
    }
  }

  /**
   * 해당 animal 정보를 삭제하는 함수
   */
  public void delAnimal(Animal animal) {
    if (!existsAnimal(animal.getName())) {
      return;
    }

    getWritableDatabase().delete(TABLE_HAPPYHOG, NAME + " = ?", new String[]{animal.getName()});

    if (onUpdateDatabase != null) {
      onUpdateDatabase.OnDelete(animal);
    }
  }

  /**
   * 해당 animal 정보를 갱신하는 함수
   */
  public void updateAnimal(Animal animal) {
    if (!existsAnimal(animal.getName())) {
      return;
    }

    ContentValues values = makeContentValue(animal);

    getWritableDatabase().update(TABLE_HAPPYHOG, values, NAME + " = ?", new String[]{animal.getName()});

    if (onUpdateDatabase != null) {
      onUpdateDatabase.OnUpdate(animal);
    }
  }

  /**
   * DB에 해당 animal 정보를 가져 오는 함수.
   */
  public Animal selectAnimal(String name) {
    if (name == null || name.length() == 0)
      return null;

    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG +
                                                   " WHERE " + NAME + " = ?", new String[]{name});

    if (cursor == null || cursor.getCount() == 0) {
      return null;
    }

    cursor.moveToFirst();
    Animal animal = makeAnimalFromCursor(cursor);

    cursor.close();

    return animal;
  }

  public Animal selectAnimal(Animal animal) {
    return selectAnimal(animal.getName());
  }

  /**
   * DB에 모든 animal 정보를 List로 가져 오는 함수.
   *
   * @return ArrayList로 저장된 모든 animal 정보 반환.
   */
  public ArrayList<Animal> selectAllAnimals() {
    ArrayList<Animal> animals = new ArrayList<>();
    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG, null);

    if (cursor == null || cursor.getCount() == 0) {
      return animals;
    }

    while (cursor.moveToNext()) {
      Animal animal = makeAnimalFromCursor(cursor);
      animals.add(animal);

      /**
       * Test Code
       */
//      Log.i("mytag", "동물 정보");
//      Log.i("mytag", animal.getName() + " " + animal.getDescription() + " " + animal.getimagePath());
//
//      Log.i("mytag", "해당 동물의 기기 정보");
//      Log.i("mytag", animal.getDeviceInfomation().getMainMacAddress() + " " + animal.getDeviceInfomation().getSubMacAddress());
//
//      Log.i("mytag", "해당 동물의 현재 온, 습도");
//      Log.i("mytag", animal.getSensingInformation().getTemperature() + " " + animal.getSensingInformation().getHumidity());
//
//      Log.i("mytag", "해당 동물의 최대, 최소 온, 습도");
//      Log.i("mytag", animal.getEnvironmentInformation().getMaxTemperature() + " " + animal.getEnvironmentInformation().getMinTemperature());
//      Log.i("mytag", animal.getEnvironmentInformation().getMaxHumidity() + " " + animal.getEnvironmentInformation().getMinHumidity());
//
//      Log.i("mytag", "해당 동물의 릴레이 정보");
//      Log.i("mytag", animal.getRelayInformation().getWarmer() + " " + animal.getRelayInformation().getHumidifier());
//
//      Log.i("mytag", "해당 동물의 스케줄 정보");
//      ArrayList<Schedule> schedules = animal.getSchedules();
//      for (Schedule s : schedules)
//        Log.i("mytag", s.getNumRotate() + " " + s.getHour() +  " " + s.getMinute());
    }
    cursor.close();

    return animals;
  }

  private ContentValues makeContentValue(Animal animal) {
    ContentValues values = new ContentValues();
    values.put(NAME, animal.getName());
    values.put(DESCRIPTION, animal.getDescription());
    values.put(IMAGE_PATH, animal.getimagePath());

    try {
      ByteArrayOutputStream baos;
      ObjectOutputStream oos;

      String blobList[] = {DEVICE_INFORMATION, SENSING_INFORMATION, ENVIRONMENT_INFORMATION, RELAY_INFORMATION, SCHEDULE_INFORMATION};
      Object objs[] =
          {animal.getDeviceInfomation(), animal.getSensingInformation(), animal.getEnvironmentInformation(), animal.getRelayInformation(),
           animal.getSchedules()};

      for (int i = 0; i < blobList.length; i++) {
        baos = new ByteArrayOutputStream();
        oos = new ObjectOutputStream(baos);
        oos.writeObject(objs[i]);
        values.put(blobList[i], baos.toByteArray());
        oos.close();
      }
    } catch (IOException e) {
      e.printStackTrace();
    }

    return values;
  }

  private Animal makeAnimalFromCursor(Cursor cursor) {
    Animal animal = new Animal(cursor.getString(0), cursor.getString(1));
    animal.setImagePath(cursor.getString(2));

    try {
      ByteArrayInputStream bais = new ByteArrayInputStream(cursor.getBlob(3));
      ObjectInputStream ois = new ObjectInputStream(bais);
      animal.setDeviceInfomation((DeviceInformation) ois.readObject());
      ois.close();

      bais = new ByteArrayInputStream(cursor.getBlob(4));
      ois = new ObjectInputStream(bais);
      animal.setSensingInformation((SensingInformation) ois.readObject());
      ois.close();

      bais = new ByteArrayInputStream(cursor.getBlob(5));
      ois = new ObjectInputStream(bais);
      animal.setEnvironmentInformation((EnvironmentInformation) ois.readObject());
      ois.close();

      bais = new ByteArrayInputStream(cursor.getBlob(6));
      ois = new ObjectInputStream(bais);
      animal.setRelayInformation((RelayInformation) ois.readObject());
      ois.close();

      bais = new ByteArrayInputStream(cursor.getBlob(7));
      ois = new ObjectInputStream(bais);
      animal.setSchedules((FoodSchedules) ois.readObject());
      ois.close();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }

    return animal;
  }

  /**
   * 해당 animal이 DB에 존재하는지 확인하는 함수
   *
   * @return 존재하면 true, 존재하지 않으면 false
   */
  public boolean existsAnimal(String animalName) {
    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG +
                                                   " WHERE " + NAME + " = ? ", new String[]{animalName});

    if (cursor != null && cursor.getCount() != 0) {
      cursor.close();
      return true;
    }

    return false;
  }
}