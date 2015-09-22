package com.example.ngh1.yschoiannoysmebadlyui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;
import java.util.List;

/**
 * Created by ngh1 on 2015-09-22.
 */
public class ExpandableListAdapter extends BaseExpandableListAdapter {
    private Context context;
    private List<String> listDataHeader; // header titles
    // child data in format of header title, child title
    private HashMap<String, List<String>> listDataChild;
    private Intent intent;

    public ExpandableListAdapter(Context context, List<String> listDataHeader, HashMap<String, List<String>> listChildData, Intent intent) {
        this.context = context;
        this.listDataHeader = listDataHeader;
        this.listDataChild = listChildData;
        this.intent = intent;

    }

    @Override
    public Object getChild(int groupPosition, int childPosititon) {
        return this.listDataChild.get(this.listDataHeader.get(groupPosition)).get(childPosititon);
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        Log.d("getChildId", " " + childPosition);
        return childPosition;
    }

    static int countForTest = 0;
    @Override
    public View getChildView(int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        final String childText = (String) getChild(groupPosition, childPosition);
        LayoutInflater infalInflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        Log.d("android_sucks","hello"+(++countForTest)+" groupPos:"+groupPosition);

        switch (groupPosition) {
            case 0:
                Log.d("android_sucks","case0: "+countForTest);

                convertView = infalInflater.inflate(R.layout.setting_profile, null);

                final EditText nameEdt = (EditText) convertView.findViewById(R.id.nameEdt);
                EditText memoEdt = (EditText) convertView.findViewById(R.id.memoEdt);

                Button nameOkBtn = (Button) convertView.findViewById(R.id.nameOkBtn);
                Button memoOkBtn = (Button) convertView.findViewById(R.id.memoOkBtn);

                nameOkBtn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        intent.putExtra("title", nameEdt.getText().toString());
                        Toast.makeText(context, "타이틀", Toast.LENGTH_SHORT).show();
                    }
                });

                break;

            case 1:
                Log.d("android_sucks","case1: "+countForTest);
                convertView = infalInflater.inflate(R.layout.setting_sensor_configuration, null);

                break;

            case 2:
                Log.d("android_sucks","case2: "+countForTest);

                convertView = infalInflater.inflate(R.layout.setting_sensor_data, null);
                break;
        }

        return convertView;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        Log.d("getChildrenCount", " " + this.listDataChild.get(this.listDataHeader.get(groupPosition)).size());
        return this.listDataChild.get(this.listDataHeader.get(groupPosition)).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return this.listDataHeader.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        Log.d("getGroupCount", " " + this.listDataHeader.size());
        return this.listDataHeader.size();
    }

    @Override
    public long getGroupId(int groupPosition) {
        Log.d("getGroupId", " " + groupPosition);
        return groupPosition;
    }

    static int nnnnnnnnnnnn = 0;

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        String headerTitle = (String) getGroup(groupPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.setting_header, null);
        }

        Log.d("qqqqqqqqqqqqqqqqqq", " " + (++nnnnnnnnnnnn));

        TextView lblListHeader = (TextView) convertView.findViewById(R.id.settingHeader);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(headerTitle);

        return convertView;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }

    public Intent getIntent() {
        return intent;
    }
}
