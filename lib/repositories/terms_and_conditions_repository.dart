import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';

class TermsAndConditionsRepository {
  static const String key = "accepted_terms_and_condition";

  final StorageProvider _storageProvider;

  const TermsAndConditionsRepository({required StorageProvider storageProvider}) : _storageProvider = storageProvider;

  /// Reads the currently accepted T&C version.
  Future<AcceptedTermsAndConditions?> getAcceptedTermsAndConditions() async {
    var model = await _storageProvider.acceptedTermsAndConditionBox.get(key);
    return _toState(model);
  }

  /// Writes the currently accepted T&C version.
  Future<void> writeAcceptedTermsAndConditions(AcceptedTermsAndConditions acceptedTermsAndConditions) {
    return _storageProvider.acceptedTermsAndConditionBox.put(key, _fromState(acceptedTermsAndConditions));
  }

  /// Deletes the currently accepted T&C version.
  Future<void> deleteTermsAndConditionsAcceptedVersion() {
    return _storageProvider.acceptedTermsAndConditionBox.delete(key);
  }

  AcceptedTermsAndConditionsEntity _fromState(AcceptedTermsAndConditions state) {
    return AcceptedTermsAndConditionsEntity(version: state.version, acceptedAt: state.acceptedAt);
  }

  AcceptedTermsAndConditions? _toState(AcceptedTermsAndConditionsEntity? model) {
    if (model == null) {
      return null;
    }
    return AcceptedTermsAndConditions(version: model.version, acceptedAt: model.acceptedAt);
  }
}
