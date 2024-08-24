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

  // event Ennded
  insertEventEndedData(String key, NotificationType message) async {
    await notificationBox.put(key, message);
    getNotifications();
    notifyListeners();
  }

  updateMessageRead(int id) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve the event object
      var messages = notificationBox.get(id);

      if (messages != null) {
        // Update the eventEnded property
        messages.read = true;
        notificationBox.put(id, messages);
      }

      // Refresh events and notify listeners
      getNotifications();
      notifyListeners();
    });
  }

  // updateEvent(int id, EventType eventType) async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // Save the updated object back to the box
  //     notificationBox.put(id, eventType);

  //     // Refresh events and notify listeners
  //     getEvents();
  //     notifyListeners();
  //   });
  // }

  //update unclose messages
  updateUncloseMessages() {}

  deleteNNotification(int id) async {
    notificationBox.delete(id);
    getNotifications();
    notifyListeners();
  }
}
