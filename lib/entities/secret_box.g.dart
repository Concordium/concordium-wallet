// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecretBoxEntityAdapter extends TypeAdapter<SecretBoxEntity> {
  @override
  final int typeId = 2;

  @override
  SecretBoxEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecretBoxEntity(
      cipherText: (fields[0] as List).cast<int>(),
      nonce: (fields[1] as List).cast<int>(),
      mac: (fields[2] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, SecretBoxEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cipherText)
      ..writeByte(1)
      ..write(obj.nonce)
      ..writeByte(2)
      ..write(obj.mac);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretBoxEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
