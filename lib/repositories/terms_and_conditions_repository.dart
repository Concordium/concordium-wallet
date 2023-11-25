import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';

class TermsAndConditionsRepository {
  static const String key = "accepted_terms_and_condition";

  final StorageProvider _storageProvider;

  const TermsAndConditionsRepository({required StorageProvider storageProvider}) : _storageProvider = storageProvider;

  /// Reads the currently accepted T&C version.
  Future<AcceptedTermsAndConditionsState?> getAcceptedTermsAndConditions() async {
    var model = await _storageProvider.acceptedTermsAndConditionBox.get(key);
    return _toState(model);
  }

  /// Writes the currently accepted T&C version.
  Future<void> writeAcceptedTermsAndConditions(AcceptedTermsAndConditionsState acceptedTermsAndConditions) {
    return _storageProvider.acceptedTermsAndConditionBox.put(key, _fromState(acceptedTermsAndConditions));
  }

  /// Deletes the currently accepted T&C version.
  Future<void> deleteTermsAndConditionsAcceptedVersion() {
    return _storageProvider.acceptedTermsAndConditionBox.delete(key);
  }

  AcceptedTermsAndConditions _fromState(AcceptedTermsAndConditionsState state) {
    return AcceptedTermsAndConditions(version: state.version, acceptedAt: state.acceptedAt);
  }

  AcceptedTermsAndConditionsState? _toState(AcceptedTermsAndConditions? model) {
    if (model == null) {
      return null;
    }
    return AcceptedTermsAndConditionsState(version: model.version, acceptedAt: model.acceptedAt);
  }
}
