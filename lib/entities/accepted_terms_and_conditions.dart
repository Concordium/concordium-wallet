import 'package:hive_flutter/hive_flutter.dart';

part 'accepted_terms_and_conditions.g.dart';

/// Version of the Terms & Conditions accepted by the user and time of acceptance.
@HiveType(typeId: 1)
class AcceptedTermsAndConditionsEntity {
  static const table = "accepted_terms_and_conditions";

  @HiveField(0)
  final String version;
  @HiveField(1)
  final DateTime acceptedAt;

  const AcceptedTermsAndConditionsEntity({required this.version, required this.acceptedAt});
}
