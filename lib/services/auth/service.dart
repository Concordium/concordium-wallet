import 'package:concordium_wallet/services/secure_storage/service.dart';

/// Global service for persisting authentication secrets to persistent storage and verifying credentials provided by the user.
class AuthenticationService {
  /// Service for writing credentials to secure storage and reading it back.
  final SecureStorageService _secureStorage;

  const AuthenticationService(this._secureStorage);

  /// Check whether a password has been persisted to secure storage.
  Future<bool> hasPassword() async {
    final password = await _secureStorage.password;
    return password != null;
  }

  /// Verifies that the password provided by the user matches one persisted in secure storage.
  /// Throws an exception if there's no persisted password to authenticate against.
  Future<bool> checkPassword(String providedPassword) async {
    final actualPassword = await _secureStorage.password;
    if (actualPassword == null) {
      throw Exception("no password has been set");
    }
    return actualPassword == providedPassword;
  }

  /// Persists the provided password to secure storage, overwriting any exiting one.
  Future<void> setPassword(String password) async {
    await _secureStorage.writePassword(password);
    final c = await checkPassword(password);
    if (!c) {
      throw Exception('cannot persist provided password');
    }
  }

  /// Deletes the current password from secure storage.
  ///
  /// Note that until a new password is set with [setPassword],
  /// subsequent calls to [hasPassword] will return false and [checkPassword] will throw an exception.
  Future<void> resetPassword() async {
    await _secureStorage.deletePassword();
  }
}
