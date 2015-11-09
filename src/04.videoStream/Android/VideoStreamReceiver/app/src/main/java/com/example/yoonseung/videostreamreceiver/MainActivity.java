package com.example.yoonseung.videostreamreceiver;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import android.net.Uri;
import android.widget.MediaController;
import android.widget.VideoView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        VideoView videoViewForTest = (VideoView)findViewById(R.id.videoViewForTest); // yoon // get VideoView ref.
        //videoViewForTest.setBackgroundColor(0xFFFFFFFF);

        String videoAddress = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        Uri videoUri = Uri.parse(videoAddress);

        videoViewForTest.setVideoURI(videoUri);

        videoViewForTest.start();

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
