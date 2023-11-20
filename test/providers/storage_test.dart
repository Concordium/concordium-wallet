import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {

  /// Mock getApplicationDocumentsDirectory on channel plugins.flutter.io/path_provider
  mockPathProvider() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel("plugins.flutter.io/path_provider"),
          (MethodCall methodCall)  async {
            return "./test/hive_storage_test";
          }
        );
  }

  late StorageProvider storage;

  setUpAll(() async {
    mockPathProvider();
    storage = await StorageProvider.init();
  });

  tearDownAll(() => Hive.deleteFromDisk());

  tearDown(() => Hive.box<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).clear());

  test('When add accepted terms and condition to storage, then saved', () async {
    // Arrange
    const name = "foobar";
    const expectedVersion = "0.0.42";
    const networkName = NetworkName(name);
    final accepted = AcceptedTermsAndConditions.acceptNow(expectedVersion);

    // Act
    await storage.writeAcceptedTermsAndConditions(networkName, accepted);

    // Assert
    final actual = storage.getAcceptedTermsAndConditions(networkName);
    expect(actual, isNotNull);
    expect(actual!.acceptedVersion, expectedVersion);
  });

  test("When delete accepted terms and condition from storage, then empty", () async {
    // Arrange  
    const name = "foobar";
    const expectedVersion = "0.0.42";
    const networkName = NetworkName(name);
    final accepted = AcceptedTermsAndConditions.acceptNow(expectedVersion);
    await storage.writeAcceptedTermsAndConditions(networkName, accepted);
    expect(Hive.box<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).get(networkName.name), isNotNull);

    // Act
    await storage.deleteTermsAndConditionsAcceptedVersion(networkName);

    // Assert
    final actual = storage.getAcceptedTermsAndConditions(networkName);
    expect(actual, null);
  });

  test("When update accepted terms and conditions, then version updated", () async {
    // Arrange
    const name = "foobar";
    const oldVersion = "0.0.42";
    const newVersion = "0.0.84";
    const networkName = NetworkName(name);
    final oldAccepted = AcceptedTermsAndConditions.acceptNow(oldVersion);
    final newAccepted = AcceptedTermsAndConditions.acceptNow(newVersion);
    await storage.writeAcceptedTermsAndConditions(networkName, oldAccepted);
    expect(Hive.box<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).get(networkName.name), isNotNull);

    // Act
    await storage.writeAcceptedTermsAndConditions(networkName, newAccepted);

    // Assert
    final actual = storage.getAcceptedTermsAndConditions(networkName);
    expect(actual, newAccepted);
  });
}
