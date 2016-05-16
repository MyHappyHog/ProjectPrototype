package kookmin.cs.happyhog.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.models.Animal;

public class AnimalAdapter extends BaseAdapter {

  private Context context;

  private ArrayList<Animal> animals;

  public AnimalAdapter(Context context) {
    this.context = context;
  }

  public AnimalAdapter(Context context, ArrayList<Animal> animals) {
    this(context);
    this.animals = animals;

    if (animals == null) {
      this.animals = new ArrayList<>();
    }
  }

  public void addItem(Animal animal) {
    animals.add(animal);
    notifyDataSetChanged();
  }

  @Override
  public int getCount() {
    return animals.size();
  }

  @Override
  public Object getItem(int position) {
    return animals.get(position);
  }

  @Override
  public long getItemId(int position) {
    return position;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {

    if (convertView == null) {
      LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      convertView = inflater.inflate(R.layout.animal_list_item, parent, false);
    }

    TextView name = (TextView) convertView.findViewById(R.id.tv_list_title);
    TextView description = (TextView) convertView.findViewById(R.id.tv_list_memo);

    name.setText(animals.get(position).getName());
    description.setText(animals.get(position).getDescription());

    return convertView;
  }
}
