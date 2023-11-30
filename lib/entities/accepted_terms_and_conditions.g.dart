// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted_terms_and_conditions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AcceptedTermsAndConditionsEntityAdapter extends TypeAdapter<AcceptedTermsAndConditionsEntity> {
  @override
  final int typeId = 1;

  @override
  AcceptedTermsAndConditionsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcceptedTermsAndConditionsEntity(
      version: fields[0] as String,
      acceptedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AcceptedTermsAndConditionsEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.version)
      ..writeByte(1)
      ..write(obj.acceptedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AcceptedTermsAndConditionsEntityAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
