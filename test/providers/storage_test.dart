import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

  setUpAll(() => mockPathProvider());

  test('When add terms and condition to storage, then saved', () async {
    // Arrange
    final storage = await StorageProvider.init();
    const name = "foobar";
    const expectedVersion = "0.0.42";
    const networkName = NetworkName(name);
    final accepted = AcceptedTermsAndConditions.acceptNow(expectedVersion);
    
    // Act
    storage.writeAcceptedTermsAndConditions(networkName, accepted);

    // Assert
    final actual = storage.getAcceptedTermsAndConditions(networkName);
    expect(actual, isNotNull);
    expect(actual!.acceptedVersion, expectedVersion);
  });
}
