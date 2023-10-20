// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inherited_tac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TacState _$TacStateFromJson(Map<String, dynamic> json) => TacState()
  .._termsAndConditionsLastVerifiedAt = json['verified'] == null
      ? null
      : DateTime.parse(json['verified'] as String)
  .._termsAndConditionsAcceptedVersion = json['version'] as String?
  .._refreshTac = json['refresh'] as bool;

Map<String, dynamic> _$TacStateToJson(TacState instance) => <String, dynamic>{
      'verified': instance._termsAndConditionsLastVerifiedAt?.toIso8601String(),
      'version': instance._termsAndConditionsAcceptedVersion,
      'refresh': instance._refreshTac,
    };
