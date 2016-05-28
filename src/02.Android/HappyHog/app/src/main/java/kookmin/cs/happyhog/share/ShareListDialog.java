package kookmin.cs.happyhog.share;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;

import kookmin.cs.happyhog.R;

public class ShareListDialog extends Dialog {

  View.OnClickListener mFacebookShareListener;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    WindowManager.LayoutParams lpWindow = new WindowManager.LayoutParams();
    lpWindow.flags = WindowManager.LayoutParams.FLAG_DIM_BEHIND;
    lpWindow.dimAmount = 0.8f;
    getWindow().setAttributes(lpWindow);

    setContentView(R.layout.dialog_share_list);

    Button facebookShare = (Button) findViewById(R.id.btn_share_facebook);
    facebookShare.setOnClickListener(mFacebookShareListener);
  }

  public ShareListDialog(Context context) {
    super(context, android.R.style.Theme_Translucent_NoTitleBar);
  }

  public void setFacebookShareListener(View.OnClickListener onClickListener) {
    mFacebookShareListener = onClickListener;
  }
}
