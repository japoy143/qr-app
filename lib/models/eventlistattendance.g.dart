// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventlistattendance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAttendanceListAdapter extends TypeAdapter<EventAttendanceList> {
  @override
  final int typeId = 3;

  @override
  EventAttendanceList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventAttendanceList(
      eventId: fields[0] as int,
      eventName: fields[1] as String,
      attendanceList: (fields[2] as List).cast<EventListAttendanceType>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventAttendanceList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.eventName)
      ..writeByte(2)
      ..write(obj.attendanceList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAttendanceListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
