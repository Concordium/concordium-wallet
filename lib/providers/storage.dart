import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for interacting with [Hive].
class StorageProvider {
  final Box<AcceptedTermsAndConditions> _acceptedTermsAndConditionBox;
  
  const StorageProvider._(this._acceptedTermsAndConditionBox);

  static Future<StorageProvider> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();

    return StorageProvider._(
      await Hive.openBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table)
    );
  }

  /// Register all adapters needed for typed boxes.
  static void _registerAdapters() {
    Hive.registerAdapter(AcceptedTermsAndConditionsAdapter());
  }

  /// Opens all boxes asynchronously.
  static Future<void> _openBoxes() async {
    final atcFuture = Hive.openBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table);
    await Future.wait([atcFuture]);
  }  

  /// Reads the currently accepted T&C version.
  AcceptedTermsAndConditions? getAcceptedTermsAndConditions(NetworkName networkName) {
    return _acceptedTermsAndConditionBox.get(networkName.name);
  }

  /// Writes the currently accepted T&C version.
  Future<void> writeAcceptedTermsAndConditions(NetworkName networkName, AcceptedTermsAndConditions acceptedTermsAndConditions) {
      return _acceptedTermsAndConditionBox.put(networkName.name, acceptedTermsAndConditions);
  }

  /// Deletes the currently accepted T&C version.
  Future<void> deleteTermsAndConditionsAcceptedVersion(NetworkName networkName) {
    return _acceptedTermsAndConditionBox.delete(networkName.name);
  }
}
