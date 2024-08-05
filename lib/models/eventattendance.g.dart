// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eventattendance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAttendanceAdapter extends TypeAdapter<EventAttendance> {
  @override
  final int typeId = 2;

  @override
  EventAttendance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventAttendance(
      id: fields[0] as int,
      eventId: fields[1] as int,
      officerName: fields[2] as String,
      studentId: fields[3] as int,
      studentName: fields[4] as String,
      studentCourse: fields[5] as String,
      studentYear: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventAttendance obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.officerName)
      ..writeByte(3)
      ..write(obj.studentId)
      ..writeByte(4)
      ..write(obj.studentName)
      ..writeByte(5)
      ..write(obj.studentCourse)
      ..writeByte(6)
      ..write(obj.studentYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAttendanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
