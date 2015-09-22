package com.example.ngh1.yschoiannoysmebadlyui;

import android.app.Activity;
import android.os.Bundle;
import android.widget.ExpandableListView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by ngh1 on 2015-09-21.
 */
public class Setting extends Activity {

    ExpandableListAdapter listAdapter;
    ExpandableListView expListView;
    List<String> listDataHeader;
    HashMap<String, List<String>> listDataChild;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.setting);

        expListView = (ExpandableListView) findViewById(R.id.settingLayout);

        prepareListData();
        listAdapter = new ExpandableListAdapter(this, listDataHeader, listDataChild, getIntent());

        expListView.setAdapter(listAdapter);
        expListView.expandGroup(0);

        expListView.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {
            @Override
            public void onGroupExpand(int groupPosition) {
                int groupCount = listAdapter.getGroupCount();
                for (int i = 0; i < groupCount; i++) {
                    if (i != groupPosition) {
                        expListView.collapseGroup(i);
                    }
                }
            }
        });

        setResult(RESULT_OK, listAdapter.getIntent());
    }


    /*
     * Preparing the list data
     */
    private void prepareListData() {
        listDataHeader = new ArrayList<String>();
        listDataChild = new HashMap<String, List<String>>();

        listDataHeader.add("Profile");
        listDataHeader.add("Sensor Configuration");
        listDataHeader.add("Sensor Data");


        // Adding child data
        List<String> dummy1 = new ArrayList<String>();
        dummy1.add("dummy data");

        List<String> dummy2 = new ArrayList<String>();
        dummy2.add("dummy data");

        List<String> dummy3= new ArrayList<String>();
        dummy3.add("dummy data");

        listDataChild.put(listDataHeader.get(0), dummy1); // Header, Child data
        listDataChild.put(listDataHeader.get(1), dummy2);
        listDataChild.put(listDataHeader.get(2), dummy3);
    }
}
