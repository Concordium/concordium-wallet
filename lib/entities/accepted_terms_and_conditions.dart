import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'accepted_terms_and_conditions.g.dart';

/// Version of the Terms & Conditions accepted by the user.
@HiveType(typeId: 1)
class AcceptedTermsAndConditions {
  static const table = "accepted_terms_and_conditions";

  @HiveField(1)
  final String acceptedVersion;
  @HiveField(2)
  final DateTime acceptedAt;

  AcceptedTermsAndConditions({required this.acceptedVersion, required this.acceptedAt});

  factory AcceptedTermsAndConditions.acceptNow(String acceptedVersion) {
    return AcceptedTermsAndConditions(acceptedVersion: acceptedVersion, acceptedAt: DateTime.now());
  }

  /// Whether the accepted version is valid with respect to the provided valid version.
  bool isValid(TermsAndConditions tac) {
    return acceptedVersion == tac.version;
  }  
}
