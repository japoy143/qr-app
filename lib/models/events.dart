import 'package:hive/hive.dart';

part 'events.g.dart';

@HiveType(typeId: 0)
class EventType {
  @HiveField(0)
  int id;
  @HiveField(1)
  String eventName;
  @HiveField(2)
  String eventDescription;
  @HiveField(3)
  DateTime startTime;
  @HiveField(4)
  DateTime eventDate;
  @HiveField(5)
  String? eventStatus;

  EventType(
      {required this.id,
      required this.eventName,
      required this.eventDescription,
      required this.eventDate,
      required this.startTime,
      this.eventStatus});
}
