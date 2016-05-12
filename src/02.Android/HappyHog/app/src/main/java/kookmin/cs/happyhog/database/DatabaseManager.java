package kookmin.cs.happyhog.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import kookmin.cs.happyhog.models.Animal;

/**
 * DB를 조작하는 클래스. 싱글톤 패턴 적용.
 * 최초 H3Application 함수에서 create로 인스턴스화하고
 * getInstance 함수로 인스턴스를 얻을 수 있다.
 */
public class DatabaseManager extends SQLiteOpenHelper {

  private static final String DB_NAME = "HAPPYHOG";
  private static final int DB_VERSION = 1;

  private static final String TYPE_TEXT = " TEXT";
  private static final String PRIMARY_KEY = " PRIMARY KEY";
  private static final String COMMA_SEP = ",";

  private static final String TABLE_HAPPYHOG = "HAPPYHOG_Animal";
  private static final String NAME = "name";
  private static final String DESCRIPTION = "description";
  private static final String MAC_ADDRESS = "mac_address";

  private static final String CREATE_TABLE =
      "CREATE TABLE " + TABLE_HAPPYHOG + "(" +
      NAME + TYPE_TEXT + PRIMARY_KEY + COMMA_SEP +
      DESCRIPTION + TYPE_TEXT + COMMA_SEP +
      MAC_ADDRESS + TYPE_TEXT + ")";

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
    if (existsAnimal(animal)) {
      return;
    }

    ContentValues values = new ContentValues();
    values.put(NAME, animal.getName());
    values.put(DESCRIPTION, animal.getDescription());
    values.put(MAC_ADDRESS, animal.getMacAdress());

    getWritableDatabase().insert(TABLE_HAPPYHOG, null, values);
  }

  /**
   * 해당 animal 정보를 삭제하는 함수
   */
  public void delAnimal(Animal animal) {
    if (!existsAnimal(animal)) {
      return;
    }

    getWritableDatabase().delete(TABLE_HAPPYHOG, NAME + " = ?", new String[]{animal.getName()});
  }

  /**
   * 해당 animal 정보를 갱신하는 함수
   */
  public void updateAnimal(Animal animal) {
    if (!existsAnimal(animal)) {
      return;
    }

    ContentValues values = new ContentValues();
    values.put(NAME, animal.getName());
    values.put(DESCRIPTION, animal.getDescription());
    values.put(MAC_ADDRESS, animal.getMacAdress());

    getWritableDatabase().update(TABLE_HAPPYHOG, values, NAME + " = ?", new String[]{animal.getName()});
  }

  /**
   * DB에 해당 animal 정보를 가져 오는 함수.
   */
  public Animal getAnimal(String name) {
    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG +
                                                   "WHERE " + NAME + " = ?", new String[]{name});

    if (cursor == null || cursor.getCount() == 0) {
      return null;
    }

    cursor.moveToFirst();
    Animal animal = new Animal();
    animal.setName(cursor.getString(0));
    animal.setDescription(cursor.getString(1));
    animal.setMacAdress(cursor.getString(2));
    cursor.close();

    return animal;
  }

  /**
   * DB에 모든 animal 정보를 List로 가져 오는 함수.
   *
   * @return ArrayList로 저장된 모든 animal 정보 반환.
   */
  public List<Animal> getAllAnimals() {
    List<Animal> animals = Collections.emptyList();
    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG, null);

    if (cursor == null || cursor.getCount() == 0) {
      return null;
    }

    animals = new ArrayList<>();
    while (cursor.moveToNext()) {
      Animal animal = new Animal();
      animal.setName(cursor.getString(0));
      animal.setDescription(cursor.getString(1));
      animal.setMacAdress(cursor.getString(2));

      animals.add(animal);
    }
    cursor.close();

    return animals;
  }

  /**
   * 해당 animal이 DB에 존재하는지 확인하는 함수
   *
   * @return 존재하면 true, 존재하지 않으면 false
   */
  public boolean existsAnimal(Animal animal) {
    Cursor cursor = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE_HAPPYHOG +
                                                   " WHERE " + NAME + " = ? ", new String[]{animal.getName()});

    if (cursor != null && cursor.getCount() != 0) {
      cursor.close();
      return true;
    }

    return false;
  }
}