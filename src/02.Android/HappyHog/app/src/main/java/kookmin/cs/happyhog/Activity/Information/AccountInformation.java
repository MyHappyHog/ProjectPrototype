package kookmin.cs.happyhog.Activity.Information;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import butterknife.Bind;
import butterknife.ButterKnife;
import kookmin.cs.happyhog.R;

public class AccountInformation extends AppCompatActivity {
  @Bind(R.id.tv_infomation)
  TextView infoText;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.information_text);
    ButterKnife.bind(this);

    infoText.setText("안녕 계정이라고해");
  }
}
