// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsAndConditions _$TermsAndConditionsFromJson(Map<String, dynamic> json) => TermsAndConditions(
      Uri.parse(json['url'] as String),
      json['version'] as String,
    );

Map<String, dynamic> _$TermsAndConditionsToJson(TermsAndConditions instance) => <String, dynamic>{
      'url': instance.url.toString(),
      'version': instance.version,
    };
