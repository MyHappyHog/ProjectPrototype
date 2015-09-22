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
import android.widget.ListView;
import android.widget.TextView;

public class MainActivity extends Activity implements View.OnClickListener {
    public static final int ACTIVITY_SETTING = 1;

    private FrameLayout flContainer;
    private ImageButton sharedSnsBtn, cameraBtn, feedBtn, settingBtn;
    private SettingDatabase db;

    private TextView title, memo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setDatabase();
        setMainLayout();
        setButtons();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.sharedSnsBtn:

                break;
            case R.id.cameraBtn:

                break;
            case R.id.feedBtn:

                break;
            case R.id.settingBtn:
                Intent intent = new Intent(getApplicationContext(), Setting.class);
                startActivityForResult(intent, ACTIVITY_SETTING);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case ACTIVITY_SETTING:
                    title.setText(data.getStringExtra("title"));
                    db.putString("title", data.getStringExtra("title"));
                    break;
            }
        }
    }

    private void setButtons() {
        sharedSnsBtn = (ImageButton) findViewById(R.id.sharedSnsBtn);
        cameraBtn = (ImageButton) findViewById(R.id.cameraBtn);
        feedBtn = (ImageButton) findViewById(R.id.feedBtn);
        settingBtn = (ImageButton) findViewById(R.id.settingBtn);

        sharedSnsBtn.setOnClickListener(this);
        cameraBtn.setOnClickListener(this);
        feedBtn.setOnClickListener(this);
        settingBtn.setOnClickListener(this);
    }

    private void setFrameLayoutMenu() {
        String[] navItems = {"Brown", "Cadet Blue", "Dark Olive Green", "Dark Orange", "Golden Rod"};
        ListView lvNavList;

        lvNavList = (ListView) findViewById(R.id.lv_activity_main_nav_list);
        flContainer = (FrameLayout) findViewById(R.id.fl_activity_main_container);

        lvNavList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, navItems));
        lvNavList.setOnItemClickListener(new DrawerItemClickListener());
    }

    private void setDatabase() {
        db = new SettingDatabase(this, "H3");
    }

    private void setMainLayout() {
        setFrameLayoutMenu();

        title = (TextView) findViewById(R.id.title);
        memo = (TextView) findViewById(R.id.memo);

        title.setText(db.getString("title", "H's house"));
        memo.setText(db.getString("memo", "Happy Hedgehog House!"));
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
            }

            flContainer.setBackgroundColor(Color.parseColor(backgroundColor));
        }
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
