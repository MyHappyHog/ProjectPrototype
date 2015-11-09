package com.example.ngh1.dynamic_graph;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import org.achartengine.GraphicalView;

/**
 * @class : MainActivity
 * @description : dynamic graph test
 */
public class MainActivity extends AppCompatActivity {
    private static GraphicalView view;
    private static Thread thread;

    private DynamicLineGraph dLine = new DynamicLineGraph(); // dynamic line graph object

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    /**
     * @method dynamicGrpahHandler
     * @param views : nothing to do
     * @description : When DynamicLineGrpah Button in activity_main.xml is clicked, run this method
     */
    public void dynamicGraphHandler (View views) {
        view = dLine.getView(this);
        setContentView(view);

        thread = new Thread() {
            public void run() {
                for (int i = 0; i < 100; i++) {
                    try {
                        Thread.sleep(2000);
                    }
                    catch (InterruptedException e) {
                        e.printStackTrace();
                    }

                    Point p = MockData.getDataFromReceiver(i);

                    if (i >= 10) {
                        dLine.nextFixedDisp(i, 0, 100);
                    }
                    dLine.addNewPoints(p);
                    view.repaint();
                }
            }
        };

        thread.start();
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
