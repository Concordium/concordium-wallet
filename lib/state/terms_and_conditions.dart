import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:flutter/foundation.dart';

/// Version of the Terms & Conditions accepted by the user.
class AcceptedTermsAndConditions {
  /// Accepted version.
  final String version;

  const AcceptedTermsAndConditions({required this.version});

  /// Whether the accepted version is valid with respect to the provided valid version.
  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}

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

/// State component of the currently accepted and valid Terms & Conditions.
class TermsAndConditionAcceptance extends ChangeNotifier {
  /// Service used to persist the accepted T&C version.
  final SharedPreferencesService _prefs;

  /// Currently accepted T&C.
  ///
  /// The accepted version is persisted into shared preferences.
  AcceptedTermsAndConditions? accepted;
  /// Currently valid T&C.
  ValidTermsAndConditions? valid;

  TermsAndConditionAcceptance(this._prefs) {
    final acceptedVersion = _prefs.termsAndConditionsAcceptedVersion;
    if (acceptedVersion != null) {
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion));
    }
  }

  /// Update the currently accepted T&C and persist the new value.
  ///
  /// Use [resetAccepted] to revoke acceptance.
  void userAccepted(AcceptedTermsAndConditions tac) {
    accepted = tac;
    _prefs.updateTermsAndConditionsAcceptedVersion(tac.version);
    notifyListeners();
  }

  /// Updates the currently valid T&C.
  void validVersionUpdated(ValidTermsAndConditions tac) {
    valid = tac;
    notifyListeners();
  }

  /// Revokes T&C acceptance and delete it from persistence.
  void resetAccepted() {
    accepted = null;
    _prefs.updateTermsAndConditionsAcceptedVersion(null);
    notifyListeners();
  }

  /// Resets the valid T&C.
  ///
  /// This should trigger a reload and re-verification of the validity of the acceptance.
  void resetValid() {
    valid = null;
    notifyListeners();
  }

  /// Resets the update time of the currently valid T&C (if present).
  ///
  /// This method is not likely to have any uses besides maybe testing.
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
