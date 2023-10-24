import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tacAcceptedVersionKey = 'tac:accepted_version';

  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  String? get termsAndConditionsAcceptedVersion => _prefs.getString(_tacAcceptedVersionKey);

  void setTermsAndConditionsAcceptedVersion(String? v) {
    if (v == null) {
      _prefs.remove(_tacAcceptedVersionKey);
    } else {
      _prefs.setString(_tacAcceptedVersionKey, v);
    }
  }
}
