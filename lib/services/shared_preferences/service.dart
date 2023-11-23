import 'package:shared_preferences/shared_preferences.dart';

/// Service for interacting with [SharedPreferences].
class SharedPreferencesService {
  /// String key associated with the persisted accepted T&C version.
  static const _tacAcceptedVersionKey = 'tac:accepted_version';
  static const _passwordKey = 'password';

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

  /// Reads the password.
  String? get password => _prefs.getString(_passwordKey);

  /// Writes the password.
  Future<void> writePassword(String password) async {
    await _prefs.setString(_passwordKey, password);
  }

  Future<void> deletePassword() async {
    await _prefs.remove(_passwordKey);
  }
}
