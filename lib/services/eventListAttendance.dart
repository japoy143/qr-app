import 'package:hive/hive.dart';
import 'package:qr_app/models/eventlistattendance.dart';
import 'package:qr_app/models/types.dart';

class EventListAttendanceDatabase {
  late Box<EventAttendanceList> _box;

  Box<EventAttendanceList> EventAttendanceListDatabaseIntialization() {
    _box = Hive.box<EventAttendanceList>('eventAttendanceListBox');
    // try {
    //   _box.put(
    //       5555,
    //       EventAttendanceList(
    //           eventId: 5555,
    //           eventName: 'zander',
    //           attendanceList: [
    //             EventListAttendanceType(
    //                 eventId: 5555,
    //                 officerId: 2222,
    //                 officerName: 'romel',
    //                 studentId: 1111,
    //                 studentName: 'Rain',
    //                 studentCourse: 'BSIT',
    //                 studentYear: '4')
    //           ]));
    //   print('added');
    // } catch (e) {
    //   print(e);
    // }

    return _box;
  }
}
