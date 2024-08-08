import 'package:hive/hive.dart';

part 'eventsid.g.dart';

@HiveType(typeId: 4)
class EventsId {
  @HiveField(0)
  int eventID;

  EventsId({required this.eventID});
}
