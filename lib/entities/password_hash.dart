import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_hash.g.dart';

@JsonSerializable()
class PasswordHashEntity {

  final List<int> passwordHash;
  final List<int> salt;

  PasswordHashEntity({required this.passwordHash, required this.salt});

  factory PasswordHashEntity.fromJson(Map<String, dynamic> json) => _$PasswordHashEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordHashEntityToJson(this);
}
