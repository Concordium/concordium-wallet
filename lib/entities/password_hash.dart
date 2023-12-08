import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_hash.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class PasswordHash {
  static const table = "password_hash";

  @HiveField(0)
  final List<int> passwordHash;
  @HiveField(1)
  final List<int> salt;

  PasswordHash({required this.passwordHash, required this.salt});

  factory PasswordHash.fromJson(Map<String, dynamic> json) => _$PasswordHashFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordHashToJson(this);
}
