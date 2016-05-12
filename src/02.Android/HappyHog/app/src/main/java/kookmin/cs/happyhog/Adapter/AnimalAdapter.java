package kookmin.cs.happyhog.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import kookmin.cs.happyhog.R;

/**
 * Created by sloth on 2016-04-07.
 */
public class AnimalAdapter extends BaseAdapter {
  private Context context;

  public AnimalAdapter(Context context) {
    this.context = context;
  }

  @Override
  public int getCount() {
    return 1;
  }

  @Override
  public Object getItem(int position) {
    return null;
  }

  @Override
  public long getItemId(int position) {
    return 0;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {

    if (convertView == null) {
      LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      convertView = inflater.inflate(R.layout.animal_list_item, parent, false);
    }

    return convertView;
  }
}
