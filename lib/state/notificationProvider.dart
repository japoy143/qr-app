import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/notifications.dart';

class NotificationProvider extends ChangeNotifier {
  // create box
  var notificationBox = Hive.box<NotificationType>('notificationBox');
  List<NotificationType> notificationList = [];

  getNotifications() async {
    var data = notificationBox.values.toList();
    notificationList = data;
  }

  //get event specific event
  bool containsEvent(int id) {
    var event = notificationBox.containsKey(id);
    return event;
  }

  //insert events
  insertData(int id, NotificationType message) async {
    await notificationBox.put(id, message);
    getNotifications();
    notifyListeners();
  }

  // updateEventEndedData(int id) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Retrieve the event object
  //     var eventObject = notificationBox.get(id);

  //     if (eventObject != null) {
  //       // Update the eventEnded property
  //       eventObject.eventEnded = true;
  //       notificationBox.put(id, eventObject);
  //     }

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  // updateEvent(int id, EventType eventType) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Save the updated object back to the box
  //     notificationBox.put(id, eventType);

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  // deleteEvent(int id) async {
  //   notificationBox.delete(id);
  //   getEvents();
  //   notifyListeners();
  // }
}
