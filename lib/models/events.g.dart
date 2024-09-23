// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 0;

  @override
  EventType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventType(
      id: fields[0] as int,
      eventName: fields[1] as String,
      eventDescription: fields[2] as String,
      eventDate: fields[4] as DateTime,
      startTime: fields[3] as DateTime,
      eventStatus: fields[5] as String?,
      eventPlace: fields[7] as String,
      key: fields[6] as String,
      endTime: fields[8] as DateTime,
      eventEnded: fields[9] as bool,
      eventPenalty: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventName)
      ..writeByte(2)
      ..write(obj.eventDescription)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.eventDate)
      ..writeByte(5)
      ..write(obj.eventStatus)
      ..writeByte(6)
      ..write(obj.key)
      ..writeByte(7)
      ..write(obj.eventPlace)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.eventEnded)
      ..writeByte(10)
      ..write(obj.eventPenalty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
