import 'package:concordium_wallet/services/shared_preferences/service.dart';

class AuthenticationService {
  final SharedPreferencesService _prefs;

  const AuthenticationService(this._prefs);

  String _loadActualPassword() {
    final res = _prefs.password;
    if (res == null) {
      throw Exception("no password has been set");
    }
    return res;
  }

  /// Check whether a password has been stored.
  bool canAuthenticate() {
    try {
      _loadActualPassword();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Attempts to authenticate the user using the provided password.
  /// Returns true if authentication was successful.
  /// Throws an exception if there's no persisted password to authenticate against.
  bool authenticate(String providedPassword) {
    final actualPassword = _loadActualPassword();
    return actualPassword == providedPassword;
  }

  Future<bool> setPassword(String password) async {
    await _prefs.writePassword(password);
    // Automatically authenticate the user.
    return authenticate(password);
  }

  Future<void> resetPassword() async {
    await _prefs.deletePassword();
  }
}
