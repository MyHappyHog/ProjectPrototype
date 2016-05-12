package kookmin.cs.happyhog.Activity;

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

/**
 * Created by sloth on 2016-04-07.
 */
public class ProfileActivity extends AppCompatActivity {

  boolean isVisible = false;

  @Bind(R.id.btn_profile_arrow)
  ImageButton mArrowButton;

  @Bind(R.id.expandable_option)
  RelativeLayout mExpandableGroup;

  /**
   * 확장가능한 옵션을 확장하거나 숨기는 버튼의 콜백 함수.
   * @param view
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
   * @param view
   */
  @OnClick(R.id.btn_profile_change)
  public void changeProfile(View view) {
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
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar_profile);
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
