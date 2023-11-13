import 'package:shared_preferences/shared_preferences.dart';

/// Service for interacting with [SharedPreferences].
class SharedPreferencesService {
  /// String key associated with the persisted accepted T&C version.
  static const _tacAcceptedVersionKey = 'tac:accepted_version';

  /// Wrapped instance.
  final SharedPreferences _prefs;

  const SharedPreferencesService(this._prefs);

  /// Reads the currently accepted T&C version.
  String? get termsAndConditionsAcceptedVersion => _prefs.getString(_tacAcceptedVersionKey);

  /// Writes the currently accepted T&C version.
  Future<void> writeTermsAndConditionsAcceptedVersion(String version) async {
    await _prefs.setString(_tacAcceptedVersionKey, version);
  }

  /// Deletes the currently accepted T&C version.
  Future<void> deleteTermsAndConditionsAcceptedVersion() async {
    await _prefs.remove(_tacAcceptedVersionKey);
  }
}
