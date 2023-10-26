import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter/foundation.dart';

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

class TermsAndConditionAcceptance extends ChangeNotifier {
  final SharedPreferencesService _prefs;

  AcceptedTermsAndConditions? accepted;
  ValidTermsAndConditions? valid;

  TermsAndConditionAcceptance(this._prefs) {
    final acceptedVersion = _prefs.termsAndConditionsAcceptedVersion;
    if (acceptedVersion != null) {
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion));
    }
  }

  void userAccepted(AcceptedTermsAndConditions tac) {
    accepted = tac;
    _prefs.setTermsAndConditionsAcceptedVersion(tac.version);
    notifyListeners();
  }

  void validVersionUpdated(ValidTermsAndConditions tac) {
    valid = tac;
    notifyListeners();
  }

  void resetAccepted() {
    accepted = null;
    _prefs.setTermsAndConditionsAcceptedVersion(null);
    notifyListeners();
  }

  void resetValid() {
    valid = null;
    notifyListeners();
  }

  // Temporary - for testing.
  void testResetValidTime() {
    final valid = this.valid;
    if (valid != null) {
      validVersionUpdated(
        ValidTermsAndConditions(
          termsAndConditions: valid.termsAndConditions,
          refreshedAt: DateTime.fromMicrosecondsSinceEpoch(0),
        ),
      );
    }
  }
}
