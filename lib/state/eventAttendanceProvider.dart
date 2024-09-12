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
            studentYear: attendance['student_year'],
            isDataSaveOffline: false);
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

      //get all event attendance
      List<EventAttendance> userAttendedList = user.map((attendance) {
        return EventAttendance(
            id: attendance['id'],
            eventId: attendance['event_id'],
            officerName: attendance['officer_name'],
            studentId: attendance['student_id'],
            studentName: attendance['student_name'],
            studentCourse: attendance['student_course'],
            studentYear: attendance['student_year'],
            isDataSaveOffline: false);
      }).toList();

      //get the student with the same event id
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

      List<EventAttendance> allEvents = eventAttendanceBox.values.toList();

      List filteredAttend = allEvents
          .where(
              (student) => student.eventId == eventId && student.eventId == id)
          .toList();

      if (filteredAttend.isEmpty) {
        return false;
      }

      return true;
    }
  }

  //TODO:here problem
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

      EventAttendance eventData = EventAttendance(
          id: event.id,
          eventId: event.eventId,
          officerName: event.officerName,
          studentId: event.studentId,
          studentName: event.studentName,
          studentCourse: event.studentCourse,
          studentYear: event.studentYear,
          isDataSaveOffline: true);

      await eventAttendanceBox.put(userSchoolId, eventData);
      getEventAttendance();
      notifyListeners();
      logger.t('successfully 303 added event Attendance');
    } catch (e) {
      logger.e('error 303 event Attendance  $e');

      EventAttendance eventData = EventAttendance(
          id: event.id,
          eventId: event.eventId,
          officerName: event.officerName,
          studentId: event.studentId,
          studentName: event.studentName,
          studentCourse: event.studentCourse,
          studentYear: event.studentYear,
          isDataSaveOffline: true);

      int badger = int.parse('${event.id}${event.studentId}');

      eventAttendanceBox.add(eventData);
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

  getOfflineSaveEventAttendance() async {
    var allEventAttendance = eventAttendanceBox.values.toList();

    List<EventAttendance> filteredOffline = allEventAttendance
        .where((element) => element.isDataSaveOffline == true)
        .toList();

    logger.e(filteredOffline.length);

    var data = filteredOffline.map((ids) {
      return {
        'event_id': ids.eventId,
        'student_id': ids.studentId,
        'student_name': ids.studentName,
        'officer_name': ids.officerName,
        'student_course': ids.studentCourse,
        'student_year': ids.studentYear
      };
    }).toList();

    data.forEach((element) {
      logger.e('${element}   event attendance');
    });

    try {
      await Supabase.instance.client
          .from('event_attendance_extras')
          .insert(data);
    } catch (e) {
      logger.e('error $e savig offline data');
    }
  }
}
