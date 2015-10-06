package com.example.ngh1.yschoiannoysmebadlyui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class MainActivity extends Activity implements View.OnClickListener {
    public static final int ACTIVITY_SETTING = 4;
    public static final int TUTORIAL_SETTING = 5;

    private FrameLayout flContainer;
    private ImageButton sharedSnsBtn, cameraBtn, feedBtn, settingBtn;
    private SettingDatabase db;

    private TextView profileCage, profileMemo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        db = new SettingDatabase(this, "H3");
        profileCage = (TextView) findViewById(R.id.profileCage);
        profileMemo = (TextView) findViewById(R.id.profileMemo);

        runTutorial();
        setMainLayout();
        setButtons();
    }

    @Override
    public void onClick(View v) {
        Intent intent = null;

        switch (v.getId()) {
            case R.id.sharedSnsBtn:

                break;
            case R.id.cameraBtn:


                break;
            case R.id.feedBtn:
                intent = new Intent(getApplicationContext(), Client.class);
                startActivity(intent);

                break;
            case R.id.settingBtn:
                intent = new Intent(getApplicationContext(), Setting.class);
                startActivityForResult(intent, ACTIVITY_SETTING);
                break;

            case R.id.profileImage:
                intent = new Intent(getApplicationContext(), VideoStreaming.class);
                startActivity(intent);

                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case ACTIVITY_SETTING:
                    if (data.getStringExtra(Constants.profileCage) != null) {
                        db.putString(Constants.profileCage, data.getStringExtra(Constants.profileCage));
                    }
                    if (data.getStringExtra(Constants.profileMemo) != null) {
                        db.putString(Constants.profileMemo, data.getStringExtra(Constants.profileMemo));
                    }

                    profileCage.setText(db.getString(Constants.profileCage, getString(R.string.default_title)));
                    profileMemo.setText(db.getString(Constants.profileMemo, getString(R.string.default_memo)));

                    break;
            }
        }
        else if (resultCode == RESULT_CANCELED) {
            // error handling
        }
    }

    private void runTutorial() {
        boolean isTutorialSet = db.getBoolean("isTutorialSet", false);

        // if tutorial activity create, add case ACTIVITY_TUTORIAL_SETTING in onActivityResult()
        if (!isTutorialSet) {
            db.putString(Constants.profileCage, getString(R.string.default_title));
            db.putString(Constants.profileMemo, getString(R.string.default_memo));

            profileCage.setText(db.getString(Constants.profileCage, getString(R.string.default_title)));
            profileMemo.setText(db.getString(Constants.profileMemo, getString(R.string.default_memo)));

            db.putInt(Constants.nCage, 1);
            db.putBoolean("isTutorialSet", true);
        }
    }

    private void setButtons() {
        sharedSnsBtn = (ImageButton) findViewById(R.id.sharedSnsBtn);
        cameraBtn = (ImageButton) findViewById(R.id.cameraBtn);
        feedBtn = (ImageButton) findViewById(R.id.feedBtn);
        settingBtn = (ImageButton) findViewById(R.id.settingBtn);

        ImageView imageView = (ImageView) findViewById(R.id.profileImage);
        imageView.setOnClickListener(this);

        sharedSnsBtn.setOnClickListener(this);
        cameraBtn.setOnClickListener(this);
        feedBtn.setOnClickListener(this);
        settingBtn.setOnClickListener(this);
    }

    private void setFrameLayoutMenu() {
        String[] navItems = {"Brown", "Cadet Blue", "Dark Olive Green", "Dark Orange", "Golden Rod", "default setting"};
        ListView lvNavList;

        lvNavList = (ListView) findViewById(R.id.lv_activity_main_nav_list);
        flContainer = (FrameLayout) findViewById(R.id.fl_activity_main_container);

        lvNavList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, navItems));
        lvNavList.setOnItemClickListener(new DrawerItemClickListener());
    }

    private void setMainLayout() {
        setFrameLayoutMenu();

        profileCage.setText(db.getString(Constants.profileCage, getString(R.string.default_title)));
        profileMemo.setText(db.getString(Constants.profileMemo, getString(R.string.default_memo)));
    }

    private class DrawerItemClickListener implements ListView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> adapter, View view, int position, long id) {
            String backgroundColor = null;

            switch (position) {
                case 0: backgroundColor = "#A52A2A"; break;
                case 1: backgroundColor = "#5F9EA0"; break;
                case 2: backgroundColor = "#556B2F"; break;
                case 3: backgroundColor = "#FF8C00"; break;
                case 4: backgroundColor = "#DAA520"; break;
                case 5: backgroundColor = "#FFFDF8";
                    setDefaultSetting();
                    break;
            }

            flContainer.setBackgroundColor(Color.parseColor(backgroundColor));
        }
    }

    public void setDefaultSetting() {
        db.putString(Constants.profileCage, getString(R.string.default_title));
        db.putString(Constants.profileMemo, getString(R.string.default_memo));

        profileCage.setText(db.getString(Constants.profileCage, getString(R.string.default_title)));
        profileMemo.setText(db.getString(Constants.profileMemo, getString(R.string.default_memo)));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
