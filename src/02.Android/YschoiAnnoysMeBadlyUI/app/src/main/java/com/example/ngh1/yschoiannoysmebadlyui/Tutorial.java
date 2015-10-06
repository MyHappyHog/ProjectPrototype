package com.example.ngh1.yschoiannoysmebadlyui;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;

/**
 * Created by ngh1 on 2015-10-07.
 */
public class Tutorial extends Activity{
    Intent intent = getIntent();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tutorial);


        setResult(RESULT_OK, intent);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            setResult(RESULT_CANCELED, intent);
        }
        return super.onKeyDown(keyCode, event);
    }
}
