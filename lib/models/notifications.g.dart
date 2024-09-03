// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 5;

  @override
  NotificationType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationType(
      id: fields[0] as int,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      body: fields[3] as String,
      time: fields[4] as String,
      read: fields[5] as bool,
      isOpen: fields[6] as bool,
      notificationKey: fields[7] as String,
      notificationId: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.read)
      ..writeByte(6)
      ..write(obj.isOpen)
      ..writeByte(7)
      ..write(obj.notificationKey)
      ..writeByte(8)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
