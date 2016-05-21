package kookmin.cs.happyhog.activity;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.InputType;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.Toast;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.database.DatabaseManager;
import kookmin.cs.happyhog.models.DeviceInformation;
import kookmin.cs.happyhog.wifi.H3WiFiManager;

public class ProfileActivity extends AppCompatActivity {

  private boolean isVisible = false;

  private boolean create;
  private H3WiFiManager wifiManager;

  private EditText editText;

  private DeviceInformation devInfo;
  private String password;
  private String originalName;

  private Handler mHandler = new Handler();
  private Runnable backPressTask = new Runnable() {
    @Override
    public void run() {
      onBackPressed();
    }
  };

  @Bind(R.id.btn_profile_arrow)
  ImageButton mArrowButton;

  @Bind(R.id.expandable_option)
  RelativeLayout mExpandableGroup;

  @Bind(R.id.expandable_option2)
  RelativeLayout mExpandableGroup2;

  @Bind(R.id.expandable_option3)
  RelativeLayout mExpandableGroup3;

  @Bind(R.id.edit_profile_title)
  EditText mEditName;

  @Bind(R.id.edit_profile_memo)
  EditText mEditDescriptiion;

  @Bind(R.id.edit_profile_main_mac)
  EditText mEditMainMac;

  @Bind(R.id.edit_profile_sub_mac)
  EditText mEditSubMac;

  @Bind(R.id.edit_profile_ssid)
  EditText mEditSSID;

  /**
   * 확장가능한 옵션을 확장하거나 숨기는 버튼의 콜백 함수.
   */
  @OnClick(R.id.btn_profile_arrow)
  public void changeVisibleOption(View view) {
    if (isVisible) {
      mArrowButton.setImageResource(R.drawable.button_down_arrow);
      mExpandableGroup.setVisibility(View.GONE);
      mExpandableGroup2.setVisibility(View.GONE);
      mExpandableGroup3.setVisibility(View.GONE);

    } else {
      mArrowButton.setImageResource(R.drawable.button_up_arrow);
      mExpandableGroup.setVisibility(View.VISIBLE);
      mExpandableGroup2.setVisibility(View.VISIBLE);
      mExpandableGroup3.setVisibility(View.VISIBLE);
    }
    isVisible = !isVisible;
  }

  /**
   * 동물 프로필을 새로 만들거나 변경하는 버튼 콜백 함수.
   */
  @OnClick(R.id.btn_profile_change)
  public void changeProfile(View view) {
    String editName = mEditName.getText().toString();
    String editDescription = mEditDescriptiion.getText().toString();

    devInfo.setMainMacAdress(mEditMainMac.getText().toString());
    devInfo.setSubMacAddress(mEditSubMac.getText().toString());
    devInfo.setSsid(mEditSSID.getText().toString());

    hideKeyboard(getCurrentFocus());

    if (editName.equals("") || editDescription.equals("") ||
        devInfo.getMainMacAddress().equals("") || devInfo.getSubMacAddress().equals("") || devInfo.getSsid().equals("")) {
      Toast.makeText(this, getResources().getText(R.string.profile_no_typing), Toast.LENGTH_SHORT).show();
      return;
    }

    // DB에 동물이 존재하는지 확인
    DatabaseManager databaseManager = DatabaseManager.getInstance();
    if (!originalName.equalsIgnoreCase(editName) && databaseManager.existsAnimal(editName)) {
      Toast.makeText(this, getResources().getText(R.string.database_exist_animal), Toast.LENGTH_SHORT).show();
      return;
    }

    Intent data = new Intent();

    data.putExtra(Define.EXTRA_NAME, editName);
    data.putExtra(Define.EXTRA_DESCRIPTION, editDescription);
    data.putExtra(Define.EXTRA_DEVICE_INFORMATION, devInfo);

    setResult(Activity.RESULT_OK, data);

    if (create) {
      /**
       * EditText 객체 생성, 입력 타입은 패스워드로 마지막 타이핑 글자 외에는 가려짐.
       */
      editText = new EditText(this);
      editText.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);

      /**
       * 다이어로그 생성 및 세팅, 위에서 만든 EditText 뷰를 보여 줌.
       */
      AlertDialog.Builder dialog = new AlertDialog.Builder(this)
          .setTitle("[" + devInfo.getSsid() + "]" + getResources().getText(R.string.profile_request_password))
          .setView(editText);

      /**
       * OK 버튼 및 클릭 이벤트 생성.
       */
      dialog.setPositiveButton(getResources().getText(R.string.dialog_ok), new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
          hideKeyboard(editText);
          dialog.dismiss();
          password = editText.getText().toString();
          settingNewDevice();
        }
      });

      /**
       * CANCLE 버튼 및 클릭 이벤트 생성.
       */
      dialog.setNegativeButton(getResources().getText(R.string.dialog_cancle), new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
          hideKeyboard(editText);
          dialog.cancel();
        }
      });

      dialog.show();
    } else {
      onBackPressed();
    }
  }

  private void settingNewDevice() {
    if (wifiManager == null) {
      wifiManager = new H3WiFiManager(this);
      wifiManager.setDeviceInfo(devInfo, password);
      wifiManager.registerReceiver();
      wifiManager.setOnCompleteAnimalListener(new H3WiFiManager.OnCompleteAnimalListener() {
        @Override
        public void onComplete() {
          mHandler.post(backPressTask);
        }
      });
    } else {
      wifiManager.setDeviceInfo(devInfo, password);
      wifiManager.enableWiFi();
    }
  }

  private void hideKeyboard(View v) {
    if (v == null) {
      return;
    }

    InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_profile);
    ButterKnife.bind(this);

    /**
     * 툴바(액션바) 설정.
     */
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    setSupportActionBar(toolbar);
    getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    getSupportActionBar().setDisplayShowTitleEnabled(false);

    Intent data = getIntent();
    if (data != null) {
      create = data.getBooleanExtra(Define.EXTRA_CREATE, false);

      mEditName.setText(data.getStringExtra(Define.EXTRA_NAME));
      mEditDescriptiion.setText(data.getStringExtra(Define.EXTRA_DESCRIPTION));

      devInfo = (DeviceInformation) data.getSerializableExtra(Define.EXTRA_DEVICE_INFORMATION);

      mEditMainMac.setText(devInfo.getMainMacAddress());
      mEditSubMac.setText(devInfo.getSubMacAddress());
      mEditSSID.setText(devInfo.getSsid());

      originalName = mEditName.getText().toString();

      // startActivity 경로에 따라 ssid의 수정 가능 여부 결정
      setModifiable(mEditMainMac, create);
      setModifiable(mEditSubMac, create);
      setModifiable(mEditSSID, create);
    }
  }

  private void setModifiable(EditText target, boolean modifiable) {
    if (target != null) {
      target.setFocusable(modifiable);
      target.setCursorVisible(modifiable);
    }
  }
  @Override
  public void onDestroy() {
    super.onDestroy();
    if (wifiManager != null) {
      wifiManager.unRegisterReceiver();
    }
  }

  /**
   * 툴바의 백(Back)키 콜백 함수
   */
  @Override
  public boolean onSupportNavigateUp() {
    onBackPressed();
    return true;
  }
}
