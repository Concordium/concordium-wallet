import 'package:concordium_wallet/entities/secret_box.dart';
import 'package:concordium_wallet/exceptions/secret_storage_exception.dart';
import 'package:concordium_wallet/providers/secret_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

/// Integration test class for secrect storage usages.
///
/// Test are implemented as integration test since implementation differs on web and
/// mobile and integration test are run on all supported platforms in our CI.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late SecretStorageProvider storage;

  Future<void> deleteHiveFromDisk() async {
    try {
      // [Hive.deleteFromDisk] doesn't close by itself on
      // web https://github.com/isar/hive/pull/734.
      await Hive.deleteFromDisk().timeout(const Duration(seconds: 1));
    } catch (_) {}
  }

  Future<void> clearMobileStorage() async {
    const mobileStorage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    await mobileStorage.deleteAll();
  }

  setUpAll(() async {
    await Hive.initFlutter();
  });

  setUp(() async {
    storage = await SecretStorageProviderFactory.create();
  });  

  tearDown(() async {
    if (kIsWeb) {
      await deleteHiveFromDisk();
    } else {
      await clearMobileStorage();
    }
  });

  testWidgets("When set, read and delete from storage, then update storage correctly", (widgetTester) async {
    // Arrange
    await storage.setPassword("password");
    const String key = "foo";
    const String value = "bar";

    // Act
    await storage.set(key, value);
    final beforeDelete = await storage.read(key);
    await storage.delete(key);
    final afterDelete = await storage.read(key);

    // Assert
    expect(afterDelete, isNull);
    expect(beforeDelete, value);
  });

  testWidgets("Given no password set, when check if exist, then return false", (widgetTester) async {
    // Act
    final actual = await storage.hasPassword();

    // Assert
    expect(actual, false);
  });

  testWidgets("When set password, then password is set and one can unlock", (widgetTester) async {
    // Arrange
    const String password = "foobar";

    // Act
    final hasPasswordBefore = await storage.hasPassword();
    await storage.setPassword(password);
    final hasPasswordAfter = await storage.hasPassword();
    final succeeded = await storage.unlock(password);

    // Assert
    expect(hasPasswordBefore, false);
    expect(hasPasswordAfter, true);
    expect(succeeded, true);
  });

  testWidgets("When unlock with wrong password, then return false", (widgetTester) async {
    // Arrange
    const String password = "foobar";
    await storage.setPassword(password);

    // Act
    final unlocked = await storage.unlock("somethingElse");

    // Assert
    expect(unlocked, false);
  });

  testWidgets("Given no password set, when trying to unlock, then throw exception", (widgetTester) async {
    // Arrange
    dynamic actualError;
    
    // Acts
    try {
      await storage.unlock("password");
    } on SecretStorageException catch (e) {
      actualError = e;
    }

    // Assert
    expect(actualError, isA<SecretStorageException>());
    expect((actualError as SecretStorageException).error, SecretStorageError.noPassword);
  });

  if (kIsWeb) {
    testWidgets("Given web, when not unlocked, then throw exception box hasn't been opened", (widgetTester) async {
      // Arrange
      const String key = "foo";
      dynamic actualError;

      // Act
      try {
        await storage.read(key);
      } on SecretStorageException catch (e) {
        actualError = e;
      }
      expect(actualError, isA<SecretStorageException>());
      expect((actualError as SecretStorageException).error, SecretStorageError.encryptedBoxNotOpened);
    });
  }
}
