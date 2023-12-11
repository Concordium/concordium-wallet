import 'dart:convert';
import 'dart:math';

import 'package:concordium_wallet/entities/password_hash.dart';
import 'package:concordium_wallet/entities/secret_box.dart';
import 'package:concordium_wallet/exceptions/secret_storage_exception.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class SecretStorage {
  static String passwordObfuscationKey = "password_obfuscation";

  /// Set an user password.
  Future<void> setPassword(String password);

  /// Checks if the users has set a password.
  Future<bool> hasPassword();

  /// From given user password validates if it is correct and unlocks
  /// any encrypted storages.
  ///
  /// Throws [SecretStorageException] if no password exist in storage to compare with.
  Future<bool> unlock(String password);

  /// Read value at [key] in storage.
  ///
  /// Throws [SecretStorageException] with error [SecretStorageError.noPassword] if no password exist in storage to compare with.
  ///
  /// If [kIsWeb] and neither [setPassword] or [unlock] has been called then [SecretStorageError.encryptedBoxNotOpened]
  /// is returned in exception.
  Future<String?> read(String key);

  /// Delete value at [key] in storage.
  ///
  /// Throws [SecretStorageException] if no password exist in storage to compare with.
  ///
  /// If [kIsWeb] and neither [setPassword] or [unlock] has been called then [SecretStorageError.encryptedBoxNotOpened]
  /// is returned in exception.
  Future<void> delete(String key);

  /// Write [value] at [key] in storage.
  ///
  /// Throws [SecretStorageException] if [kIsWeb] and neither [setPassword] or [unlock] has been called then [SecretStorageError.encryptedBoxNotOpened]
  /// is returned in exception.
  Future<void> set(String key, String value);

  /// Checks if password has been set and throws exception if none is present.
  Future<void> _validatePasswordPresent() async {
    if (!(await hasPassword())) {
      throw SecretStorageException.noPassword();
    }
  }
}

class SecretStorageFactory {
  static Future<SecretStorage> create() async {
    if (kIsWeb) {
      return await WebSecretStorage.create();
    }
    return MobileSecretStorage.create();
  }
}

class MobileSecretStorage extends SecretStorage {
  final FlutterSecureStorage storage;

  MobileSecretStorage._({required this.storage});

  factory MobileSecretStorage.create() {
    const storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    return MobileSecretStorage._(storage: storage);
  }

  @override
  Future<void> delete(String key) async {
    await _validatePasswordPresent();
    return await storage.delete(key: key);
  }

  @override
  Future<String?> read(String key) async {
    await _validatePasswordPresent();
    return await storage.read(key: key);
  }

  @override
  Future<void> set(String key, String value) async {
    return storage.write(key: key, value: value);
  }

  @override
  Future<bool> hasPassword() {
    return storage.containsKey(key: SecretStorage.passwordObfuscationKey);
  }

  @override
  Future<void> setPassword(String password) async {
    final algorithm = _getHashAlgorithm();
    final salt = _createSalt();

    final secret = await algorithm.deriveKeyFromPassword(password: password, nonce: salt);

    final passwordHash = PasswordHashEntity(passwordHash: await secret.extractBytes(), salt: salt);
    final passwordHashJson = jsonEncode(passwordHash.toJson());
    return set(SecretStorage.passwordObfuscationKey, passwordHashJson);
  }

  @override
  Future<bool> unlock(String password) async {
    final storedPassword = await read(SecretStorage.passwordObfuscationKey);

    if (storedPassword == null) {
      throw SecretStorageException.noPassword();
    }
    final passwordHash = PasswordHashEntity.fromJson(jsonDecode(storedPassword));

    final algorithm = _getHashAlgorithm();
    final passwordHashGiven = await algorithm.deriveKeyFromPassword(password: password, nonce: passwordHash.salt);
    final passwordHashGivenBytes = await passwordHashGiven.extractBytes();

    return listEquals(passwordHashGivenBytes, passwordHash.passwordHash);
  }

  Argon2id _getHashAlgorithm() {
    return Argon2id(memory: 10 * 1000, parallelism: 2, iterations: 1, hashLength: 32);
  }

  List<int> _createSalt() {
    final secureRandom = Random.secure();
    Uint8List randomBytes = Uint8List(32);
    for (var i = 0; i < randomBytes.length; i++) {
      randomBytes[i] = secureRandom.nextInt(256);
    }
    return randomBytes;
  }
}

class WebSecretStorage extends SecretStorage {
  static String encryptedBoxTable = "encryptedBox";

  final LazyBox<SecretBoxEntity> nonEcryptedStorage;
  LazyBox<String>? encryptedBox;

  WebSecretStorage._({required this.nonEcryptedStorage});

  static Future<WebSecretStorage> create() async {
    _registerAdapters();
    final nonEcryptedStorage = await Hive.openLazyBox<SecretBoxEntity>(SecretBoxEntity.table);
    return WebSecretStorage._(nonEcryptedStorage: nonEcryptedStorage);
  }

  static _registerAdapters() {
    Hive.registerAdapter(SecretBoxEntityAdapter());
  }

  @override
  Future<void> delete(String key) async {
    await _validatePasswordPresent();
    return await encryptedBox!.delete(key);
  }

  @override
  Future<String?> read(String key) async {
    await _validatePasswordPresent();
    return encryptedBox!.get(key);
  }

  @override
  Future<void> set(String key, String value) async {
    return encryptedBox!.put(key, value);
  }

  @override
  Future<bool> hasPassword() async {
    return nonEcryptedStorage.containsKey(SecretStorage.passwordObfuscationKey);
  }

  @override
  Future<bool> unlock(String password) async {
    final secretBoxEntity = await nonEcryptedStorage.get(SecretStorage.passwordObfuscationKey);
    if (secretBoxEntity == null) {
      throw SecretStorageException.noPassword();
    }
    final secretBox = _mapFromSecretBoxEntity(secretBoxEntity);
    final algorithm = AesGcm.with256bits();
    final secretKey = await _generateCorrectLengthSecretKey(password);
    try {
      final decryption = await algorithm.decrypt(secretBox, secretKey: secretKey);

      if (!Hive.isBoxOpen(encryptedBoxTable)) {
        encryptedBox = await _openEncryptionBox(decryption);
      }
    } catch (_) {
      // wrong password since decryption failed.
      return false;
    }

    return true;
  }

  @override
  Future<void> _validatePasswordPresent() async {
    if (encryptedBox == null) {
      throw SecretStorageException.encryptedBoxNotOpened();
    }
    super._validatePasswordPresent();
  }

  @override
  Future<void> setPassword(String password) async {
    final key = Hive.generateSecureKey();
    final secretKey = await _generateCorrectLengthSecretKey(password);

    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(key, secretKey: secretKey);

    final secretBoxEntity = _mapFromSecretBox(secretBox);
    await nonEcryptedStorage.put(SecretStorage.passwordObfuscationKey, secretBoxEntity);

    encryptedBox = await _openEncryptionBox(key);
  }

  Future<LazyBox<String>> _openEncryptionBox(List<int> key) {
    return Hive.openLazyBox<String>(encryptedBoxTable, encryptionCipher: HiveAesCipher(key));
  }

  SecretBox _mapFromSecretBoxEntity(SecretBoxEntity entity) {
    return SecretBox(entity.cipherText, nonce: entity.nonce, mac: Mac(entity.mac));
  }

  SecretBoxEntity _mapFromSecretBox(SecretBox box) {
    return SecretBoxEntity(cipherText: box.cipherText, nonce: box.nonce, mac: box.mac.bytes);
  }

  /// Generate a secret key from [password] with correct array length of
  /// 32 which is needed by [AesGcm.with256bits].
  Future<SecretKey> _generateCorrectLengthSecretKey(String password) async {
    final sink = Sha256().newHashSink();
    sink.add(password.codeUnits);
    sink.close();
    final hash = await sink.hash();
    return SecretKey(hash.bytes);
  }
}
