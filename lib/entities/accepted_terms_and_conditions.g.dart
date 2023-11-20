// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted_terms_and_conditions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AcceptedTermsAndConditionsAdapter
    extends TypeAdapter<AcceptedTermsAndConditions> {
  @override
  final int typeId = 1;

  @override
  AcceptedTermsAndConditions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcceptedTermsAndConditions(
      acceptedVersion: fields[1] as String,
      acceptedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AcceptedTermsAndConditions obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.acceptedVersion)
      ..writeByte(2)
      ..write(obj.acceptedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcceptedTermsAndConditionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
