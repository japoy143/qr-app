import 'package:hive/hive.dart';

part 'users.g.dart';

@HiveType(typeId: 1)
class UsersType {
  @HiveField(0)
  int schoolId;
  @HiveField(1)
  String key;
  @HiveField(2)
  String userName;
  @HiveField(3)
  String userCourse;
  @HiveField(4)
  String userYear;
  @HiveField(5)
  String userPassword;
  @HiveField(6)
  bool isAdmin;
  @HiveField(7)
  String userProfile;

  UsersType(
      {required this.schoolId,
      required this.key,
      required this.userName,
      required this.userCourse,
      required this.userYear,
      required this.userPassword,
      required this.isAdmin,
      required this.userProfile});
}
