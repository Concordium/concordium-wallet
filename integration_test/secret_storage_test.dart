import 'package:concordium_wallet/entities/password_hash.dart';
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

  tearDown(() async {
    if (kIsWeb) {
      var box = await Hive.openBox<PasswordHash>(PasswordHash.table);
      box.deleteFromDisk();
    } else {
      var storage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
      await storage.deleteAll();
    }
  });

  testWidgets("When set, read and delete from storage, then update storage correctly", (widgetTester) async {
    // Arrange
    var storage = await SecretStorageFactory.create();
    const String key = "foo";
    const String value = "bar";

    // Act
    await storage.set(key, value);
    var beforeDelete = await storage.read(key);
    await storage.delete(key);
    var afterDelete = await storage.read(key);

    // Assert
    expect(beforeDelete, isNotNull);
    expect(afterDelete, isNull);
    expect(beforeDelete, value);
  });

  testWidgets("Given no password set, when check if exist, then return false", (widgetTester) async {
    // Arrange
    var storage = await SecretStorageFactory.create();

    // Act
    var actual = await storage.hasPassword();

    // Assert
    expect(actual, false);
  });

  testWidgets("When set password, then password set and one can unlock", (widgetTester) async {
    // Arrange
    var storage = await SecretStorageFactory.create();
    const String password = "foobar";

    // Act
    var hasPasswordBefore = await storage.hasPassword();
    await storage.setPassword(password);
    var hasPasswordAfter = await storage.hasPassword();
    var succeeded = await storage.unlock(password);

    // Assert
    expect(hasPasswordBefore, false);
    expect(hasPasswordAfter, true);
    expect(succeeded, true);
  });

  testWidgets("When unlock with wrong password, then return false", (widgetTester) async {
    // Arrange
    var storage = await SecretStorageFactory.create();
    const String password = "foobar";
    await storage.setPassword(password);

    // Act
    var unlocked = await storage.unlock("somethingElse");

    // Assert
    expect(unlocked, false);    
  });

  testWidgets("Given no password set, when trying to unlock, then throw exception", (widgetTester) async {
    // Arrange
    var storage = await SecretStorageFactory.create();
    
    // Act & Assert
    await expectLater(storage.unlock("password"), throwsA(isA<SecretStorageException>()));
  });
}
