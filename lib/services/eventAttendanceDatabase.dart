// import 'package:hive/hive.dart';
// import 'package:qr_app/models/eventattendance.dart';

// class EventAttendanceDatabase {
//   late Box<EventAttendance> _box;

//   Box<EventAttendance> eventAttendanceDatabaseInitialization() {
//     _box = Hive.box<EventAttendance>("_eventAttendanceBox");

//     if (_box.isEmpty) {
//       _box.put(
//           220,
//           EventAttendance(
//               id: 220,
//               eventId: 220,
//               officerName: 'Lowe',
//               studentId: 220,
//               studentName: 'James',
//               studentCourse: 'BSIT',
//               studentYear: '4'));
//     }
//     return _box;
//   }
// }
