package com.example.ngh1.yschoiannoysmebadlyui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.EditText;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;

/**
 * Created by ngh1 on 2015-09-22.
 */
public class ExpandableListAdapter extends BaseExpandableListAdapter {

    private List<String> listDataHeader;
    private HashMap<String, List<String>> listDataChild;

    private Context context;
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
        return childPosition;
    }

    static int countForTest = 0;
    @Override
    public View getChildView(int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {

        final String childText = (String) getChild(groupPosition, childPosition);

        LayoutInflater infalInflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        switch (groupPosition) {
            case 0:
                convertView = infalInflater.inflate(R.layout.setting_profile, null);

                final EditText nameEdt = (EditText) convertView.findViewById(R.id.nameEdt);
                final EditText memoEdt = (EditText) convertView.findViewById(R.id.memoEdt);

                nameEdt.addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {

                    }

                    @Override
                    public void afterTextChanged(Editable s) {
                        if (!s.toString().trim().equals("")) {
                            intent.putExtra(Constants.profileCage, s.toString());
                        }
                    }
                });

                memoEdt.addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {

                    }

                    @Override
                    public void afterTextChanged(Editable s) {
                        if (!s.toString().trim().equals("")) {
                            intent.putExtra(Constants.profileMemo, s.toString());
                        }
                    }
                });

                break;

            case 1:
                convertView = infalInflater.inflate(R.layout.setting_sensor_configuration, null);
                break;

            case 2:
                convertView = infalInflater.inflate(R.layout.setting_sensor_data, null);
                break;
        }
        return convertView;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return this.listDataChild.get(this.listDataHeader.get(groupPosition)).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return this.listDataHeader.get(groupPosition);
    }

    @Override
    public int getGroupCount() {
        return this.listDataHeader.size();
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        String headerTitle = (String) getGroup(groupPosition);
        if (convertView == null) {
            LayoutInflater infalInflater = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = infalInflater.inflate(R.layout.setting_header, null);
        }

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
