package kookmin.cs.happyhog.Activity.Information;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import butterknife.Bind;
import butterknife.ButterKnife;
import kookmin.cs.happyhog.R;

public class PersonalInformation extends AppCompatActivity {
  @Bind(R.id.tv_infomation)
  TextView infoText;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.information_text);
    ButterKnife.bind(this);

    infoText.setText("나는 지난 여름 너가 그 땅에서 한 일을 알고 있다");
  }
}
