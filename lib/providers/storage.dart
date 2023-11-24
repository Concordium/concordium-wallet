import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for interacting with [Hive].
class StorageProvider {
  final Box<AcceptedTermsAndConditions> _acceptedTermsAndConditionBox;

  const StorageProvider._(this._acceptedTermsAndConditionBox);

  static Future<StorageProvider> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();

    return StorageProvider._(Hive.box<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table));
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

  Box<AcceptedTermsAndConditions> get acceptedTermsAndConditionBox => _acceptedTermsAndConditionBox;
}
