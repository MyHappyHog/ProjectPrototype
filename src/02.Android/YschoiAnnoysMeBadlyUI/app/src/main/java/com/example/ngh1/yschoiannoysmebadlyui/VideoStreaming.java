package com.example.ngh1.yschoiannoysmebadlyui;

import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.VideoView;

/**
 * Created by ngh1 on 2015-10-06.
 */
public class VideoStreaming extends AppCompatActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.video_streaming);

        VideoView videoViewForTest = (VideoView)findViewById(R.id.videoViewForTest); // yoon // get VideoView ref.
        //videoViewForTest.setBackgroundColor(0xFFFFFFFF);

        String videoAddress = "http://vevoplaylist-live.hls.adaptive.level3.net/vevo/ch1/appleman.m3u8";
        Uri videoUri = Uri.parse(videoAddress);

        videoViewForTest.setVideoURI(videoUri);

        videoViewForTest.start();
    }
}
