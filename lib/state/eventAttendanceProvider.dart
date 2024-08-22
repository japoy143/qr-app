import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';

class EventAttendanceProvider extends ChangeNotifier {
  // create box
  var eventAttendanceBox = Hive.box<EventAttendance>('eventAttendanceBox');
  List<EventAttendance> eventAttendanceList = [];

  getEventAttendance() async {
    var data = eventAttendanceBox.values.toList();
    eventAttendanceList = data;
  }

  //get event specific event
  bool containsStudent(String id) {
    var event = eventAttendanceBox.containsKey(id);
    return event;
  }

  //insert event attendance
  insertData(String userSchoolId, EventAttendance event) async {
    await eventAttendanceBox.put(userSchoolId, event);
    getEventAttendance();
    notifyListeners();
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
