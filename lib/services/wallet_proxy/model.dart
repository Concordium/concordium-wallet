import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class TermsAndConditions {
  final Uri url;
  final String version;

  TermsAndConditions(this.url, this.version);

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) => _$TermsAndConditionsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsAndConditionsToJson(this);
}
