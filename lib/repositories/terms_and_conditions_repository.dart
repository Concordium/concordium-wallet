import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart' as states;
import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart' as models;

class TermsAndConditionsRepository {
  static const String key = "accepted_terms_and_condition";

  final StorageProvider _storageProvider;

  const TermsAndConditionsRepository({required StorageProvider storageProvider}) 
  : _storageProvider = storageProvider;

  /// Reads the currently accepted T&C version.
  states.AcceptedTermsAndConditions? getAcceptedTermsAndConditions() {
    var model = _storageProvider.acceptedTermsAndConditionBox.get(key);
    return toState(model);
  }

  /// Writes the currently accepted T&C version.
  Future<void> writeAcceptedTermsAndConditions(states.AcceptedTermsAndConditions acceptedTermsAndConditions) {
    return _storageProvider.acceptedTermsAndConditionBox.put(key, fromState(acceptedTermsAndConditions));
  }

  /// Deletes the currently accepted T&C version.
  Future<void> deleteTermsAndConditionsAcceptedVersion() {
    return _storageProvider.acceptedTermsAndConditionBox.delete(key);
  }

  models.AcceptedTermsAndConditions fromState(states.AcceptedTermsAndConditions state) {
    return models.AcceptedTermsAndConditions(version: state.version, acceptedAt: state.acceptedAt);
  }

  states.AcceptedTermsAndConditions? toState(models.AcceptedTermsAndConditions? model) {
    if (model == null) {
      return null;
    }
    return states.AcceptedTermsAndConditions(version: model.version, acceptedAt: model.acceptedAt);
  }
}
