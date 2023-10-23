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
  final DateTime? updatedAt;

  const ValidTermsAndConditions({required this.termsAndConditions, required this.updatedAt});

  factory ValidTermsAndConditions.updatedNow({required TermsAndConditions termsAndConditions}) {
    return ValidTermsAndConditions(termsAndConditions: termsAndConditions, updatedAt: DateTime.now());
  }
}

class TermsAndConditionsAcceptanceState {
  final AcceptedTermsAndConditions? accepted;
  final ValidTermsAndConditions? valid;

  const TermsAndConditionsAcceptanceState({required this.accepted, required this.valid});

  TermsAndConditionsAcceptanceState copyWith({AcceptedTermsAndConditions? accepted, ValidTermsAndConditions? valid}) {
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
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion));
    }
  }

  void userAccepted(AcceptedTermsAndConditions tac) {
    emit(state.copyWith(accepted: tac));
  }

  void validVersionUpdated(ValidTermsAndConditions tac) {
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
  void testResetValidTime() {
    emit(state.copyWith(valid: ValidTermsAndConditions(termsAndConditions: state.valid!.termsAndConditions, updatedAt: _zeroTime)));
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
