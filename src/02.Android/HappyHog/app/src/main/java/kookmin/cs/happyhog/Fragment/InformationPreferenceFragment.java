package kookmin.cs.happyhog.Fragment;

import android.os.Bundle;
import android.preference.PreferenceFragment;

import kookmin.cs.happyhog.R;

public class InformationPreferenceFragment extends PreferenceFragment {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    addPreferencesFromResource(R.xml.pref_setting);
  }
}
