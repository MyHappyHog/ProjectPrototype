package kookmin.cs.happyhog.fragment;

import android.os.Bundle;
import android.preference.EditTextPreference;
import android.preference.Preference;
import android.preference.PreferenceFragment;
import android.preference.SwitchPreference;

import kookmin.cs.happyhog.Define;
import kookmin.cs.happyhog.R;
import kookmin.cs.happyhog.dropbox.H3Dropbox;

public class AccountPreferenceFragment extends PreferenceFragment {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    addPreferencesFromResource(R.xml.pref_setting_account);

    findPreference(Define.AUTO_LOGIN).setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
      @Override
      public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference instanceof SwitchPreference) {
          EditTextPreference dropboxKeyPreference = (EditTextPreference) findPreference(Define.DROPBOX_KEY);

          boolean selected = Boolean.parseBoolean(newValue.toString());
          if (selected) {
            dropboxKeyPreference.setText(H3Dropbox.getInstance().getAccessToken());
          } else {
            dropboxKeyPreference.setText("");
          }
        }
        return true;
      }
    });

    Preference preference = findPreference(Define.MAIN_ANIMAL_KEY);
    String mainAnimalName = getPreferenceManager().getSharedPreferences().getString(Define.MAIN_ANIMAL_KEY, "");
    if (!mainAnimalName.equals("")) {
      preference.setSummary(mainAnimalName);
    }
  }
}
