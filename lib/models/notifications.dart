import 'package:hive/hive.dart';

part 'notifications.g.dart';

@HiveType(typeId: 5)
class NotificationType {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subtitle;
  @HiveField(3)
  String body;
  @HiveField(4)
  String time;
  @HiveField(5)
  bool read;

  NotificationType(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.body,
      required this.time,
      required this.read});
}
