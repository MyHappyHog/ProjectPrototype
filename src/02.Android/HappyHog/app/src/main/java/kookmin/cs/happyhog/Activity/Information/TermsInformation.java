package kookmin.cs.happyhog.activity.information;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import butterknife.Bind;
import butterknife.ButterKnife;
import kookmin.cs.happyhog.R;

/**
 * Created by sloth on 2016-05-15.
 */
public class TermsInformation extends AppCompatActivity {
  @Bind(R.id.tv_infomation)
  TextView infoText;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.information_text);
    ButterKnife.bind(this);

    infoText.setText("공짜입니다");
  }
}
