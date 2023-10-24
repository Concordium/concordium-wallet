import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptedTermsAndConditions {
  final String version;

  const AcceptedTermsAndConditions({required this.version});

  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}

class ValidTermsAndConditions {
  final TermsAndConditions termsAndConditions;
  final DateTime? refreshedAt;

  const ValidTermsAndConditions({required this.termsAndConditions, required this.refreshedAt});

  factory ValidTermsAndConditions.refreshedNow({required TermsAndConditions termsAndConditions}) {
    return ValidTermsAndConditions(termsAndConditions: termsAndConditions, refreshedAt: DateTime.now());
  }
}

class TermsAndConditionsAcceptanceState {
  final AcceptedTermsAndConditions? accepted;
  final ValidTermsAndConditions? valid;

  const TermsAndConditionsAcceptanceState({required this.accepted, required this.valid});
}

class TermsAndConditionAcceptance extends Cubit<TermsAndConditionsAcceptanceState> {
  final SharedPreferencesService _prefs;

  TermsAndConditionAcceptance(this._prefs) : super(const TermsAndConditionsAcceptanceState(accepted: null, valid: null)) {
    final acceptedVersion = _prefs.termsAndConditionsAcceptedVersion;
    if (acceptedVersion != null) {
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion));
    }
  }

  void userAccepted(AcceptedTermsAndConditions tac) {
    emit(TermsAndConditionsAcceptanceState(accepted: tac, valid: state.valid));
  }

  void validVersionUpdated(ValidTermsAndConditions tac) {
    emit(TermsAndConditionsAcceptanceState(accepted: state.accepted, valid: tac));
  }

  void resetAccepted() {
    emit(TermsAndConditionsAcceptanceState(accepted: null, valid: state.valid));
  }

  void resetValid() {
    emit(TermsAndConditionsAcceptanceState(accepted: state.accepted, valid: null));
  }

  // Temporary - for testing.
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
    // Persist accepted version if it changed.
    final currentAcceptedVersion = change.currentState.accepted?.version;
    final nextAcceptedVersion = change.nextState.accepted?.version;
    if (nextAcceptedVersion != currentAcceptedVersion) {
      _prefs.setTermsAndConditionsAcceptedVersion(nextAcceptedVersion);
    }
  }
}
