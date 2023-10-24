// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tac_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TacEntityAdapter extends TypeAdapter<TacEntity> {
  @override
  final int typeId = 1;

  @override
  TacEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TacEntity()
      ..version = fields[1] as String
      ..latest = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, TacEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.latest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TacEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
