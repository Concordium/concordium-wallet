// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_hash.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordHashAdapter extends TypeAdapter<PasswordHash> {
  @override
  final int typeId = 2;

  @override
  PasswordHash read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordHash(
      passwordHash: (fields[0] as List).cast<int>(),
      salt: (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, PasswordHash obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.passwordHash)
      ..writeByte(1)
      ..write(obj.salt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PasswordHashAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordHash _$PasswordHashFromJson(Map<String, dynamic> json) => PasswordHash(
      passwordHash: (json['passwordHash'] as List<dynamic>).map((e) => e as int).toList(),
      salt: (json['salt'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PasswordHashToJson(PasswordHash instance) => <String, dynamic>{
      'passwordHash': instance.passwordHash,
      'salt': instance.salt,
    };
