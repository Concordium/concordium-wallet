import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Version of the Terms & Conditions that is considered valid.
///
/// The user has to have accepted this version (or more generally, a compatible version)
/// for the acceptance to be valid.
class ValidTermsAndConditions {
  /// T&C configuration fetched from an external endpoint.
  final TermsAndConditions termsAndConditions;

  /// Latest time at which [termsAndConditions] is known to be valid.
  final DateTime refreshedAt;

  const ValidTermsAndConditions({required this.termsAndConditions, required this.refreshedAt});

  /// Constructs an instance for the provided [TermsAndConditions] with a refresh time of the current time.
  factory ValidTermsAndConditions.refreshedNow({required TermsAndConditions termsAndConditions}) {
    return ValidTermsAndConditions(termsAndConditions: termsAndConditions, refreshedAt: DateTime.now());
  }
}

class TermsAndConditionsAcceptanceState {
  /// Currently accepted T&C.
  ///
  /// The accepted version is persisted into shared preferences.
  final AcceptedTermsAndConditions? accepted;

  /// Currently valid T&C.
  final ValidTermsAndConditions? valid;

  const TermsAndConditionsAcceptanceState({required this.accepted, required this.valid});
}

/// State component of the currently accepted and valid Terms & Conditions.
class TermsAndConditionAcceptance extends Cubit<TermsAndConditionsAcceptanceState> {
  /// Service used to persist the accepted T&C version.
  final StorageProvider _storage;
  final NetworkName networkName;

  TermsAndConditionAcceptance(this._storage, this.networkName) : super(const TermsAndConditionsAcceptanceState(accepted: null, valid: null)) {

    final acceptedVersion = _storage.getAcceptedTermsAndConditions(networkName);
    if (acceptedVersion != null) {
      userAccepted(acceptedVersion);
    }
  }

  /// Update the currently accepted T&C and persist the new value.
  ///
  /// Use [resetAccepted] to revoke acceptance.
  void userAccepted(AcceptedTermsAndConditions tac) {
    emit(TermsAndConditionsAcceptanceState(accepted: tac, valid: state.valid));
  }

  /// Updates the currently valid T&C.
  void validVersionUpdated(ValidTermsAndConditions tac) {
    emit(TermsAndConditionsAcceptanceState(accepted: state.accepted, valid: tac));
  }

  /// Revokes T&C acceptance and delete it from persistence.
  void resetAccepted() {
    emit(TermsAndConditionsAcceptanceState(accepted: null, valid: state.valid));
  }

  /// Resets the valid T&C.
  ///
  /// This should trigger a reload and re-verification of the validity of the acceptance.
  void resetValid() {
    emit(TermsAndConditionsAcceptanceState(accepted: state.accepted, valid: null));
  }

  /// Resets the update time of the currently valid T&C (if present).
  ///
  /// This method is not likely to have any uses besides maybe testing.
  void testResetValidTime() {
    final valid = state.valid;
    if (valid != null) {
      validVersionUpdated(
        ValidTermsAndConditions(
          termsAndConditions: valid.termsAndConditions,
          refreshedAt: DateTime.fromMicrosecondsSinceEpoch(0),
        ),
      );
    }
  }

  @override
  void onChange(Change<TermsAndConditionsAcceptanceState> change) {
    super.onChange(change);

    if (change.currentState == change.nextState) {
      return;
    }
    // TODO: Pass success/failure status to notification service.
    _persistAcceptedVersionIfChanged(change.nextState.accepted);
  }

  Future<void> _persistAcceptedVersionIfChanged(AcceptedTermsAndConditions? nextAcceptedVersion) {
    if (nextAcceptedVersion == null) {
      return _storage.deleteTermsAndConditionsAcceptedVersion(networkName);
    }
    return _storage.writeAcceptedTermsAndConditions(networkName, nextAcceptedVersion);
  }
}
