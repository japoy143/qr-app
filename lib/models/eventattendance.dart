import 'package:hive/hive.dart';

part 'eventattendance.g.dart';

@HiveType(typeId: 2)
class EventAttendance {
  @HiveField(0)
  int id;
  @HiveField(1)
  int eventId;
  @HiveField(2)
  String officerName;
  @HiveField(3)
  int studentId;
  @HiveField(4)
  String studentName;
  @HiveField(5)
  String studentCourse;
  @HiveField(6)
  String studentYear;

  EventAttendance(
      {required this.id,
      required this.eventId,
      required this.officerName,
      required this.studentId,
      required this.studentName,
      required this.studentCourse,
      required this.studentYear});
}
