import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';

class EventAttendanceDatabase {
  late Box<EventAttendance> _box;

  Box<EventAttendance> eventAttendanceDatabaseInitialization() {
    _box = Hive.box<EventAttendance>("_eventAttendanceBox");

    return _box;
  }
}
