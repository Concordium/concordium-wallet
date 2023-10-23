import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptedTermsAndConditions {
  final String version;
  final DateTime? lastVerifiedAt; // TODO: looks like this field should be the time of fetching the current valid version

  const AcceptedTermsAndConditions({required this.version, required this.lastVerifiedAt});

  AcceptedTermsAndConditions copyWith({String? version, DateTime? lastVerifiedAt}) {
    return AcceptedTermsAndConditions(
      version: version ?? this.version,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
    );
  }

  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}

class TermsAndConditionsAcceptanceState {
  final AcceptedTermsAndConditions? accepted;
  final TermsAndConditions? valid;

  const TermsAndConditionsAcceptanceState({required this.accepted, required this.valid});

  TermsAndConditionsAcceptanceState copyWith({AcceptedTermsAndConditions? accepted, TermsAndConditions? valid}) {
    return TermsAndConditionsAcceptanceState(
      accepted: accepted ?? this.accepted,
      valid: valid ?? this.valid,
    );
  }
}

class TermsAndConditionAcceptance extends Cubit<TermsAndConditionsAcceptanceState> {
  static final _zeroTime = DateTime.fromMicrosecondsSinceEpoch(0);

  final SharedPreferencesService _preferences;

  TermsAndConditionAcceptance(this._preferences) : super(const TermsAndConditionsAcceptanceState(accepted: null, valid: null)) {
    final acceptedVersion = _preferences.termsAndConditionsAcceptedVersion;
    if (acceptedVersion != null) {
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion, lastVerifiedAt: _zeroTime));
    }
  }

  void userAccepted(AcceptedTermsAndConditions tac) {
    emit(state.copyWith(accepted: tac));
  }

  void validVersionUpdated(TermsAndConditions tac) {
    emit(state.copyWith(valid: tac));
  }

  void resetAccepted() {
    // Cannot set null value using 'copyOf'.
    emit(TermsAndConditionsAcceptanceState(accepted: null, valid: state.valid));
  }

  void resetValid() {
    // Cannot set null value using 'copyOf'.
    emit(TermsAndConditionsAcceptanceState(accepted: state.accepted, valid: null));
  }

  // Temporary - for testing.
  void testSetAcceptedVersion(String version) {
    emit(state.copyWith(accepted: state.accepted?.copyWith(version: version)));
  }

  // Temporary - for testing.
  void testResetAcceptedTime() {
    emit(state.copyWith(accepted: state.accepted?.copyWith(lastVerifiedAt: _zeroTime)));
  }

  @override
  void onChange(Change<TermsAndConditionsAcceptanceState> change) {
    super.onChange(change);
    // Persist accepted version if it changed.
    final acceptedVersion = change.nextState.accepted?.version;
    if (acceptedVersion != null && acceptedVersion != change.currentState.accepted?.version) {
      _preferences.setTermsAndConditionsAcceptedVersion(acceptedVersion);
    }
  }
}
