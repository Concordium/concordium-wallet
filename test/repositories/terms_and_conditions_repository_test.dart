import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/repositories/terms_and_conditions_repository.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  /// Mock getApplicationDocumentsDirectory on channel plugins.flutter.io/path_provider
  mockPathProvider() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel("plugins.flutter.io/path_provider"), (MethodCall methodCall) async {
      return "./test/hive_storage_test";
    });
  }

  late TermsAndConditionsRepository repository;

  setUpAll(() async {
    mockPathProvider();
    final storage = await StorageProvider.init();
    repository = TermsAndConditionsRepository(storageProvider: storage);
  });

  tearDownAll(() => Hive.deleteFromDisk());

  tearDown(() => Hive.lazyBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).clear());

  test('When add accepted terms and condition to storage, then saved', () async {
    // Arrange
    const expectedVersion = "0.0.42";
    final accepted = AcceptedTermsAndConditionsState.acceptNow(expectedVersion);

    // Act
    await repository.writeAcceptedTermsAndConditions(accepted);

    // Assert
    final actual = await repository.getAcceptedTermsAndConditions();
    expect(actual, isNotNull);
    expect(actual!.version, expectedVersion);
  });

  test("When delete accepted terms and condition from storage, then empty", () async {
    // Arrange
    const expectedVersion = "0.0.42";
    final accepted = AcceptedTermsAndConditionsState.acceptNow(expectedVersion);
    await repository.writeAcceptedTermsAndConditions(accepted);
    expect(await Hive.lazyBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).get(TermsAndConditionsRepository.key), isNotNull);

    // Act
    await repository.deleteTermsAndConditionsAcceptedVersion();

    // Assert
    final actual = await repository.getAcceptedTermsAndConditions();
    expect(actual, null);
  });

  test("When update accepted terms and conditions, then version updated", () async {
    // Arrange
    const oldVersion = "0.0.42";
    const newVersion = "0.0.84";
    final oldAccepted = AcceptedTermsAndConditionsState.acceptNow(oldVersion);
    final newAccepted = AcceptedTermsAndConditionsState.acceptNow(newVersion);
    await repository.writeAcceptedTermsAndConditions(oldAccepted);
    expect(await Hive.lazyBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table).get(TermsAndConditionsRepository.key), isNotNull);

    // Act
    await repository.writeAcceptedTermsAndConditions(newAccepted);

    // Assert
    final actual = await repository.getAcceptedTermsAndConditions();
    expect(actual, isNotNull);
    expect(actual!.acceptedAt, newAccepted.acceptedAt);
    expect(actual.version, newAccepted.version);
  });
}
