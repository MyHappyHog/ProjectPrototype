package kookmin.cs.happyhog.activity;

import android.preference.PreferenceActivity;

import java.util.List;

import kookmin.cs.happyhog.fragment.AccountPreferenceFragment;
import kookmin.cs.happyhog.fragment.InformationPreferenceFragment;
import kookmin.cs.happyhog.R;

public class InformationActivity extends PreferenceActivity {

  @Override
  public void onBuildHeaders(List<Header> target) {
    loadHeadersFromResource(R.xml.pref_header, target);
  }

  @Override
  protected boolean isValidFragment(String fragmentName) {
    return InformationPreferenceFragment.class.getName().equals(fragmentName)
           || AccountPreferenceFragment.class.getName().equals(fragmentName);
  }
}