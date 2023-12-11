import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SecretStorageException implements Exception {
  final SecretStorageError error;

  SecretStorageException(this.error);

  factory SecretStorageException.noPassword() {
    return SecretStorageException(SecretStorageError.noPassword);
  }

  factory SecretStorageException.encryptedBoxNotOpened() {
    return SecretStorageException(SecretStorageError.encryptedBoxNotOpened);
  }

  @override
  String toString() {
    return 'SecretStorageException: ${error.message}';
  }
}

enum SecretStorageError {
  /// Password hasn't been set.
  noPassword(message: "Password has not yet been set"),

  /// When [kIsWeb] secret storage depends on a [Hive] encrypted box. The box needs to
  /// be opened before one can access it.
  encryptedBoxNotOpened(message: "Encrypted box hasn't been opened");

  final String message;

  const SecretStorageError({required this.message});
}
