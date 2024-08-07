import 'package:hive/hive.dart';
import 'package:qr_app/models/eventlistattendance.dart';

class EventListAttendanceDatabase {
  late Box<EventAttendanceList> _box;

  Box<EventAttendanceList> EventAttendanceListDatabaseIntialization() {
    _box = Hive.box<EventAttendanceList>('eventAttendanceListBox');

    return _box;
  }
}
