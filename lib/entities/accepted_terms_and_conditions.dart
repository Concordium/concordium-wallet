import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'accepted_terms_and_conditions.g.dart';

/// Version of the Terms & Conditions accepted by the user.
@HiveType(typeId: 1)
class AcceptedTermsAndConditions {
  static const table = "accepted_terms_and_conditions";

  @HiveField(0)
  final String version;
  @HiveField(1)
  final DateTime acceptedAt;

  AcceptedTermsAndConditions({required this.version, required this.acceptedAt});

  factory AcceptedTermsAndConditions.acceptNow(String acceptedVersion) {
    return AcceptedTermsAndConditions(version: acceptedVersion, acceptedAt: DateTime.now());
  }

  /// Whether the accepted version is valid with respect to the provided valid version.
  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}
