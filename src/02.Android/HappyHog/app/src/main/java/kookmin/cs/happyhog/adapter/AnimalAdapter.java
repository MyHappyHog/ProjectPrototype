package kookmin.cs.happyhog.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Picasso;

import java.io.File;
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
    Log.d("mytag", "[AddItem Notify]");
  }

  public void updateItem(String target, Animal animal) {
    int index = animals.indexOf(new Animal(target, ""));

    if (index != -1) {
      animals.set(index, animal);
      notifyDataSetChanged();
      Log.d("mytag", "[UpdateItem Notify]");
    }
  }

  public void removeItem(Animal animal) {
    animals.remove(animal);
    notifyDataSetChanged();
    Log.d("mytag", "[RemoveItem Notify]");
  }

  public void updateItem(Animal animal) {
    updateItem(animal.getName(), animal);
  }

  public Animal getAnimal(int index) {
    return animals.get(index);
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

    ImageView iv = (ImageView) convertView.findViewById(R.id.btn_feed_individual);
    iv.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        Toast.makeText(context, "먹이줌", Toast.LENGTH_SHORT).show();
      }
    });

    Animal animal = animals.get(position);
    ImageView animalImage = (ImageView) convertView.findViewById(R.id.iv_feed_individual);

    if (animal.getimagePath().equals("")) {
      Picasso.with(context).load(R.drawable.default_empty_image)
          .fit()
          .into(animalImage);
    } else {
      Picasso.with(context).load(new File(animals.get(position).getimagePath()))
          .fit()
          .into(animalImage);
    }

    name.setText(animals.get(position).getName());
    description.setText(animals.get(position).getDescription());

    return convertView;
  }
}
