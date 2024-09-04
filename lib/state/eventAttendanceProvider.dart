import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventAttendanceProvider extends ChangeNotifier {
  //logger
  var logger = Logger();
  // create box
  var eventAttendanceBox = Hive.box<EventAttendance>('eventAttendanceBox');
  List<EventAttendance> eventAttendanceList = [];

  //error code 3**

  //301
  getEventAttendance() async {
    try {
      var eventAttendance =
          await Supabase.instance.client.from('event_attendance').select("*");

      List<EventAttendance> eventAttendanceData =
          eventAttendance.map((attendance) {
        return EventAttendance(
            id: attendance['id'],
            eventId: attendance['event_id'],
            officerName: attendance['officer_name'],
            studentId: attendance['student_id'],
            studentName: attendance['student_name'],
            studentCourse: attendance['student_course'],
            studentYear: attendance['student_year']);
      }).toList();

      eventAttendanceList = eventAttendanceData;
      notifyListeners();
      logger.t('successfully get data 301');
    } catch (e) {
      logger.e('error 301 getting eventAttendance $e');
      var data = eventAttendanceBox.values.toList();
      eventAttendanceList = data;
    }
  }

  //302
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

      logger.t('successfully find user 302');
      return true;
    } catch (e) {
      logger.e('error 302 event Attendance $e');
      var event = eventAttendanceBox.containsKey(id);
      return event;
    }
  }

  //303
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
      logger.t('successfully 303 added event Attendance');
    } catch (e) {
      logger.e('error 303 event Attendance  $e');
      await eventAttendanceBox.put(userSchoolId, event);
      getEventAttendance();
      notifyListeners();
    }
  }

  //304
  deleteEvent(int id) async {
    eventAttendanceBox.delete(id);
    getEventAttendance();
    notifyListeners();
    logger.t('successfully deleted eventAttendance');
  }
}
