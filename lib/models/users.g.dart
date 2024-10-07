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
      isSignupOnline: fields[8] as bool,
      isLogin: fields[9] as bool,
      eventAttended: fields[10] as String,
      isPenaltyShown: fields[11] as bool,
      lastName: fields[12] as String,
      middleInitial: fields[13] as String,
      isValidationRep: fields[14] as bool,
      isUserValidated: fields[15] as bool,
      isNotificationSend: fields[16] as bool,
      isValidationOpen: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UsersType obj) {
    writer
      ..writeByte(18)
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
      ..write(obj.userProfile)
      ..writeByte(8)
      ..write(obj.isSignupOnline)
      ..writeByte(9)
      ..write(obj.isLogin)
      ..writeByte(10)
      ..write(obj.eventAttended)
      ..writeByte(11)
      ..write(obj.isPenaltyShown)
      ..writeByte(12)
      ..write(obj.lastName)
      ..writeByte(13)
      ..write(obj.middleInitial)
      ..writeByte(14)
      ..write(obj.isValidationRep)
      ..writeByte(15)
      ..write(obj.isUserValidated)
      ..writeByte(16)
      ..write(obj.isNotificationSend)
      ..writeByte(17)
      ..write(obj.isValidationOpen);
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
