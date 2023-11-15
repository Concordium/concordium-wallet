import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

/// Response from endpoint [WalletProxyEndpoint.termsAndConditionsVersion].
@JsonSerializable()
class TermsAndConditions {
  /// URL of the T&C text.
  final Uri url;

  /// T&C version.
  final String version;

  const TermsAndConditions(this.url, this.version);

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) => _$TermsAndConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsAndConditionsToJson(this);
}
