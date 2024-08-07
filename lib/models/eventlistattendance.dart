import 'package:hive/hive.dart';
import 'package:qr_app/models/types.dart';

part 'eventlistattendance.g.dart';

@HiveType(typeId: 3)
class EventAttendanceList {
  @HiveField(0)
  int eventId;
  @HiveField(1)
  String eventName;
  @HiveField(2)
  List<EventListAttendanceType> attendanceList;

  EventAttendanceList(
      {required this.eventId,
      required this.eventName,
      required this.attendanceList});
}
