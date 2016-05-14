package kookmin.cs.happyhog.Activity;

import android.preference.PreferenceActivity;

import java.util.List;

import kookmin.cs.happyhog.Fragment.InformationPreferenceFragment;
import kookmin.cs.happyhog.R;

public class InformationActivity extends PreferenceActivity {

  @Override
  public void onBuildHeaders(List<Header> target) {
    loadHeadersFromResource(R.xml.pref_header, target);
  }

  @Override
  protected boolean isValidFragment(String fragmentName) {
    return InformationPreferenceFragment.class.getName().equals(fragmentName);
  }

}