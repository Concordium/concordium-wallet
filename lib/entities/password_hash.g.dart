// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_hash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordHashEntity _$PasswordHashEntityFromJson(Map<String, dynamic> json) =>
    PasswordHashEntity(
      passwordHash:
          (json['passwordHash'] as List<dynamic>).map((e) => e as int).toList(),
      salt: (json['salt'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PasswordHashEntityToJson(PasswordHashEntity instance) =>
    <String, dynamic>{
      'passwordHash': instance.passwordHash,
      'salt': instance.salt,
    };
