import 'package:freezed_annotation/freezed_annotation.dart';
part 'model.g.dart';
part 'model.freezed.dart';

@freezed
class TermsAndConditions with _$TermsAndConditions {
  const factory TermsAndConditions(Uri url, String version) = _TermsAndConditions;

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) => _$TermsAndConditionsFromJson(json);
}
