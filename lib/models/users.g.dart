// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersTypeAdapter extends TypeAdapter<UsersType> {
  @override
  final int typeId = 1;

  @override
  UsersType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersType(
      schoolId: fields[0] as int,
      key: fields[1] as String,
      userName: fields[2] as String,
      userCourse: fields[3] as String,
      userYear: fields[4] as String,
      userPassword: fields[5] as String,
      isAdmin: fields[6] as bool,
      userProfile: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UsersType obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.schoolId)
      ..writeByte(1)
      ..write(obj.key)
      ..writeByte(2)
      ..write(obj.userName)
      ..writeByte(3)
      ..write(obj.userCourse)
      ..writeByte(4)
      ..write(obj.userYear)
      ..writeByte(5)
      ..write(obj.userPassword)
      ..writeByte(6)
      ..write(obj.isAdmin)
      ..writeByte(7)
      ..write(obj.userProfile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
