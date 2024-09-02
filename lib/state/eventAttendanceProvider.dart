import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventAttendanceProvider extends ChangeNotifier {
  // create box
  var eventAttendanceBox = Hive.box<EventAttendance>('eventAttendanceBox');
  List<EventAttendance> eventAttendanceList = [];

  getEventAttendance() async {
    var data = eventAttendanceBox.values.toList();
    eventAttendanceList = data;
  }

  //get event specific event
  Future<bool> containsStudent(int eventId, int id) async {
    try {
      var user =
          await Supabase.instance.client.from('event_attendance').select("*");

      List<EventAttendance> userAttendedList = user.map((attendance) {
        return EventAttendance(
            id: attendance['id'],
            eventId: attendance['event_id'],
            officerName: attendance['officer_name'],
            studentId: attendance['student_id'],
            studentName: attendance['student_name'],
            studentCourse: attendance['student_course'],
            studentYear: attendance['student_year']);
      }).toList();

      List filteredAttended = userAttendedList
          .where((student) =>
              student.eventId == eventId && student.studentId == id)
          .toList();

      print(filteredAttended.length);
      if (filteredAttended.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      print('error event Attendance $e');
      var event = eventAttendanceBox.containsKey(id);
      return event;
    }
  }

  //insert event attendance
  insertData(String userSchoolId, EventAttendance event) async {
    try {
      await Supabase.instance.client.from('event_attendance').insert({
        'event_id': event.eventId,
        'student_id': event.studentId,
        'student_name': event.studentName,
        'officer_name': event.officerName,
        'student_course': event.studentCourse,
        'student_year': event.studentYear,
      });

      await eventAttendanceBox.put(userSchoolId, event);
      getEventAttendance();
      notifyListeners();
      print('successfully added event Attendance');
    } catch (e) {
      print('error $e');
      await eventAttendanceBox.put(userSchoolId, event);
      getEventAttendance();
      notifyListeners();
    }
  }

  // updateEventEndedData(int id) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Retrieve the event object
  //     var eventObject = eventAttendanceBox.get(id);

  //     if (eventObject != null) {
  //       // Update the eventEnded property
  //       eventObject.eventEnded = true;
  //       eventAttendanceBox.put(id, eventObject);
  //     }

  //     // Refresh events and notify listeners
  //     getEventAttendance();
  //     notifyListeners();
  //   });
  // }

  // updateEvent(int id, EventType eventType) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Save the updated object back to the box
  //     eventAttendanceBox.put(id, eventType);

  //     // Refresh events and notify listeners
  //     getEventAttendance();
  //     notifyListeners();
  //   });
  // }

  deleteEvent(int id) async {
    eventAttendanceBox.delete(id);
    getEventAttendance();
    notifyListeners();
  }
}
