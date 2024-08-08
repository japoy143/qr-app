// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventsid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventsIdAdapter extends TypeAdapter<EventsId> {
  @override
  final int typeId = 4;

  @override
  EventsId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventsId(
      eventID: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventsId obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.eventID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
