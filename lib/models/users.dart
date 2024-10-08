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
  @HiveField(8)
  bool isSignupOnline;
  @HiveField(9)
  bool isLogin;
  @HiveField(10)
  String eventAttended;
  @HiveField(11)
  bool isPenaltyShown;
  @HiveField(12)
  String lastName;
  @HiveField(13)
  String middleInitial;
  @HiveField(14)
  bool isValidationRep;
  @HiveField(15)
  bool isUserValidated;
  @HiveField(16)
  bool isNotificationSend;
  @HiveField(17)
  bool isValidationOpen;
  @HiveField(18)
  bool isAdminDataSave;

  UsersType(
      {required this.schoolId,
      required this.key,
      required this.userName,
      required this.userCourse,
      required this.userYear,
      required this.userPassword,
      required this.isAdmin,
      required this.userProfile,
      required this.isSignupOnline,
      required this.isLogin,
      required this.eventAttended,
      required this.isPenaltyShown,
      required this.lastName,
      required this.middleInitial,
      required this.isValidationRep,
      required this.isUserValidated,
      required this.isNotificationSend,
      required this.isValidationOpen,
      required this.isAdminDataSave});
}
