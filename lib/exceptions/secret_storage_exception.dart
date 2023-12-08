class SecretStorageException implements Exception {
  final String message;

  SecretStorageException(this.message);

  factory SecretStorageException.noPassword() {
    return SecretStorageException("Password has not yet been set");
  }

  @override
  String toString() {
    return 'SecretStorageException: $message';
  }
}
