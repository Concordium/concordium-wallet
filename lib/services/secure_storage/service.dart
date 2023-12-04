import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for interacting with [FlutterSecureStorage].
class SecureStorageService {
  /// String key associated with the password.
  static const _passwordKey = 'password';

  /// Wrapped instance.
  final FlutterSecureStorage _secureStorage;

  const SecureStorageService(this._secureStorage);

  /// Reads the password.
  Future<String?> get password => _secureStorage.read(key: _passwordKey);

  /// Writes the password.
  Future<void> writePassword(String password) async {
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  /// Deletes the password.
  Future<void> deletePassword() async {
    await _secureStorage.delete(key: _passwordKey);
  }
}
