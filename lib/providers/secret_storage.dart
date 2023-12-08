import 'dart:convert';
import 'dart:math';

import 'package:concordium_wallet/entities/password_hash.dart';
import 'package:concordium_wallet/exceptions/secret_storage_exception.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class SecretStorage {
  /// Set an user password.
  Future<void> setPassword(String password);
  /// Checks if the users has set a password.
  Future<bool> hasPassword();
  /// From given user password validates if it is correct and unlocks
  /// any encrypted storages.
  /// 
  /// Throws [SecretStorageException] if no password exist in storage to compare with.
  Future<bool>  unlock(String password);
  /// Read value at [key] in storage.
  Future<String?> read(String key);
  /// Delete value at [key] in storage.
  Future<void> delete(String key);
  /// Write [value] at [key] in storage.
  Future<void> set(String key, String value);
}

/// Interface to generate salts for encryption.
abstract class SaltGenerator {
  List<int> createSalt({int length = 32});
}

class RandomSaltGenerator implements SaltGenerator {
  final Random random;
  
  RandomSaltGenerator._({required this.random});

  factory RandomSaltGenerator.create() {
    return RandomSaltGenerator._(random: Random.secure());
  }
  
  @override
  List<int> createSalt({int length = 32}) {
    final secureRandom = Random.secure();
    Uint8List randomBytes = Uint8List(length);
    for (var i = 0; i < randomBytes.length; i++) {
      randomBytes[i] = secureRandom.nextInt(256);
    }
    return randomBytes;
  }
}

class SecretStorageFactory {
  static Future<SecretStorage> create() async {
    if (kIsWeb) {
      return await WebSecretStorage.create();
    }
    return MobileSecretStorage.create(RandomSaltGenerator.create());
  }
}

class MobileSecretStorage implements SecretStorage {
  static String passwordHashKey = "password_hash";

  final FlutterSecureStorage storage;
  final SaltGenerator saltGenerator;

  MobileSecretStorage._({required this.saltGenerator, required this.storage});

  factory MobileSecretStorage.create(SaltGenerator saltGenerator) {
    var storage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    return MobileSecretStorage._(storage: storage, saltGenerator: saltGenerator);
  }

  @override
  Future<void> delete(String key) {
    return storage.delete(key: key);
  }

  @override
  Future<String?> read(String key) {
    return storage.read(key: key);
  }

  @override
  Future<void> set(String key, String value) {
    return storage.write(key: key, value: value);
  }

  @override
  Future<bool> hasPassword() {
    return storage.containsKey(key: MobileSecretStorage.passwordHashKey);
  }

  @override
  Future<void> setPassword(String password) async {
    final algorithm = _getHashAlgorithm();
    final salt = saltGenerator.createSalt();
    
    final secret = await algorithm.deriveKeyFromPassword(password: password, nonce: salt);

    final passwordHash = PasswordHash(passwordHash: await secret.extractBytes(), salt: salt);
    final passwordHashJson = jsonEncode(passwordHash.toJson());
    return set(MobileSecretStorage.passwordHashKey, passwordHashJson);
  }

  @override
  Future<bool> unlock(String password) async {
    final storedPassword = await read(MobileSecretStorage.passwordHashKey);
    
    if(storedPassword == null) {
      throw SecretStorageException.noPassword();
    }
    final passwordHash = PasswordHash.fromJson(jsonDecode(storedPassword));

    final algorithm = _getHashAlgorithm();
    final passwordHashGiven = await algorithm.deriveKeyFromPassword(password: password, nonce: passwordHash.salt);
    final passwordHashGivenBytes = await passwordHashGiven.extractBytes();
    
    return listEquals(passwordHashGivenBytes, passwordHash.passwordHash);
  }

  Argon2id _getHashAlgorithm() {
    return Argon2id(memory: 10 * 1000, parallelism: 2, iterations: 1, hashLength: 32);
  }
}

class WebSecretStorage implements SecretStorage {
  final LazyBox<PasswordHash> nonEcryptedStorage;

  WebSecretStorage._({required this.nonEcryptedStorage});

  static Future<WebSecretStorage> create() async {
    _registerAdapters();
    final nonEcryptedStorage = await Hive.openLazyBox<PasswordHash>(PasswordHash.table);
    return WebSecretStorage._(nonEcryptedStorage: nonEcryptedStorage);
  }

  static _registerAdapters() {
    Hive.registerAdapter(PasswordHashAdapter());
  }

  @override
  Future<void> delete(String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<String> read(String key) {
    // TODO: implement read
    throw UnimplementedError();
  }

  @override
  Future<void> set(String key, String value) {
    // TODO: implement write
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPassword() {
    // TODO: implement hasPassword
    throw UnimplementedError();
  }

  @override
  Future<void> setPassword(String password) {
    // TODO: implement setPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> unlock(String password) {
    // TODO: implement unlock
    throw UnimplementedError();
  }
}
