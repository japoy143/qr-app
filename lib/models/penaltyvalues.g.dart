// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penaltyvalues.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PenaltyValuesAdapter extends TypeAdapter<PenaltyValues> {
  @override
  final int typeId = 6;

  @override
  PenaltyValues read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PenaltyValues(
      id: fields[0] as int,
      penaltyvalue: fields[1] as String,
      penaltyprice: fields[2] as int,
      isOpen: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PenaltyValues obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.penaltyvalue)
      ..writeByte(2)
      ..write(obj.penaltyprice)
      ..writeByte(3)
      ..write(obj.isOpen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PenaltyValuesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
