package kookmin.cs.happyhog.activity;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import kookmin.cs.happyhog.R;

public class ProfileActivity extends AppCompatActivity {

  boolean isVisible = false;

  @Bind(R.id.btn_profile_arrow)
  ImageButton mArrowButton;

  @Bind(R.id.expandable_option)
  RelativeLayout mExpandableGroup;

//  @Bind(R.id.edit_profile_title)
//  EditText mEditName;
//
//  @Bind(R.id.edit_profile_memo)
//  EditText mEditDescriptiion;
//
//  @Bind(R.id.edit_profile_mac)
//  EditText mEditMacaddress;

  /**
   * 확장가능한 옵션을 확장하거나 숨기는 버튼의 콜백 함수.
   */
  @OnClick(R.id.btn_profile_arrow)
  public void changeVisibleOption(View view) {
    if (isVisible) {
      mArrowButton.setImageResource(R.drawable.button_down_arrow);
      mExpandableGroup.setVisibility(View.GONE);
    } else {
      mArrowButton.setImageResource(R.drawable.button_up_arrow);
      mExpandableGroup.setVisibility(View.VISIBLE);
    }
    isVisible = !isVisible;
  }

  /**
   * 동물 프로필을 새로 만들거나 변경하는 버튼 콜백 함수.
   */
  @OnClick(R.id.btn_profile_change)
  public void changeProfile(View view) {
//    Intent data = new Intent();
//
//    String editName = mEditName.getText().toString();
//    String editDescription = mEditDescriptiion.getText().toString();
//    String editMacaddress = mEditMacaddress.getText().toString();
//
//    if (editName.equals("") || editDescription.equals("") || editMacaddress.equals("")) {
//      Toast.makeText(this, "입력하지 않은 칸이 있습니다.", Toast.LENGTH_SHORT).show();
//      return;
//    }
//
//    data.putExtra("NAME", editName);
//    data.putExtra("DESCRIPTION", editDescription);
//    data.putExtra("MACADDRESS", editMacaddress);
//
//    setResult(Activity.RESULT_OK, data);
    onBackPressed();
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
