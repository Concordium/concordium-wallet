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

  late SecretStorage storage;

  setUpAll(() async {
    await Hive.initFlutter();
    storage = await SecretStorageFactory.create();
  });

  tearDown(() async {
    if (kIsWeb) {
      await Hive.lazyBox<SecretBoxEntity>(SecretBoxEntity.table).clear();
      await Hive.lazyBox(WebSecretStorage.encryptedBoxTable).clear();
    } else {
      const mobileStorage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
      await mobileStorage.deleteAll();
    }
  });

  tearDownAll(() => Hive.deleteFromDisk());

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
    expect(beforeDelete, isNotNull);
    expect(afterDelete, isNull);
    expect(beforeDelete, value);
  });

  testWidgets("Given no password set, when check if exist, then return false", (widgetTester) async {
    // Act
    final actual = await storage.hasPassword();

    // Assert
    expect(actual, false);
  });

  testWidgets("When set password, then password set and one can unlock", (widgetTester) async {
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
    // Act & Assert
    await expectLater(storage.unlock("password"), throwsA(isA<SecretStorageException>()));
  });

  if (kIsWeb) {
    testWidgets("Given no password, when set, read and delete from storage, then throw exception", (widgetTester) async {
    // Arrange
    // TODO
    const String key = "foo";
    const String value = "bar";

    // Act
    await storage.set(key, value);
    final beforeDelete = await storage.read(key);
    await storage.delete(key);
    final afterDelete = await storage.read(key);

    // Assert
    expect(beforeDelete, isNotNull);
    expect(afterDelete, isNull);
    expect(beforeDelete, value);
  });
  }
}
