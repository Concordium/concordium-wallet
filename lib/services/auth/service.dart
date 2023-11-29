import 'package:concordium_wallet/services/secure_storage/service.dart';

class AuthenticationService {
  final SecureStorageService _secureStorage;

  const AuthenticationService(this._secureStorage);

  Future<String> _loadActualPassword() async {
    final res = await _secureStorage.password;
    if (res == null) {
      throw Exception("no password has been set");
    }
    return res;
  }

  /// Check whether a password has been stored.
  Future<bool> canAuthenticate() async {
    try {
      await _loadActualPassword();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Attempts to authenticate the user using the provided password.
  /// Returns true if authentication was successful.
  /// Throws an exception if there's no persisted password to authenticate against.
  Future<bool> authenticate(String providedPassword) async {
    final actualPassword = await _loadActualPassword();
    return actualPassword == providedPassword;
  }

  Future<bool> setPassword(String password) async {
    await _secureStorage.writePassword(password);
    // Automatically authenticate the user.
    return authenticate(password);
  }

  Future<void> resetPassword() async {
    await _secureStorage.deletePassword();
  }
}
