import 'package:shared_preferences/shared_preferences.dart';

/// Service for interacting with [SharedPreferences].
class SharedPreferencesService {
  /// String key associated with the persisted accepted T&C version.
  static const _tacAcceptedVersionKey = 'tac:accepted_version';

  /// Wrapped instance.
  final SharedPreferences _prefs;

  const SharedPreferencesService(this._prefs);

  /// Currently accepted shared preferences.
  String? get termsAndConditionsAcceptedVersion => _prefs.getString(_tacAcceptedVersionKey);

  /// Sets or deletes the currently accepted shared preferences.
  void updateTermsAndConditionsAcceptedVersion(String? v) {
    if (v == null) {
      _prefs.remove(_tacAcceptedVersionKey);
    } else {
      _prefs.setString(_tacAcceptedVersionKey, v);
    }
  }
}
