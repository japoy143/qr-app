import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/notifications.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationProvider extends ChangeNotifier {
  // create box
  var notificationBox = Hive.box<NotificationType>('notificationBox');
  List<NotificationType> notificationList = [];

  int notificationListener = 0;

  //notification cache
  var notification_cache = Hive.box('notification_cache');

  //err code 5**

  //501
  getNotifications() async {
    try {
      var messages =
          await Supabase.instance.client.from('notifications').select("*");

      List<NotificationType> allMessages = messages.map((notif) {
        return NotificationType(
            id: notif['notification_id'],
            title: notif['title'],
            subtitle: notif['subtitle'],
            body: notif['body'],
            time: notif['time'],
            read: notif['read'],
            isOpen: notif['is_open'],
            notificationKey: notif['notification_key'],
            notificationId: notif['notification_id']);
      }).toList();

      if (allMessages.isEmpty) {
        return;
      }

      allMessages.map((message) async {
        var isInNotificationBox =
            notificationBox.containsKey(message.notificationKey);

        var isInNotificationCache =
            notification_cache.containsKey(message.notificationKey);

        if (!isInNotificationBox && !isInNotificationCache) {
          await notificationBox.put(message.notificationKey, message);
        }
      });

      List<NotificationType> messageList = notificationBox.values.toList();

      notificationList = messageList;
      notifyListeners();
      print('successfully get code 501 notifications');
    } catch (e) {
      print('error code 501 notifications $e');
      var data = notificationBox.values.toList();
      notificationList = data;
      notifyListeners();
    }
  }

  //502
  //get event specific event
  bool containsEvent(int id) {
    var event = notificationBox.containsKey(id);
    return event;
  }

  //503
  //insert events
  insertData(int id, NotificationType message) async {
    try {
      var notif =
          await Supabase.instance.client.from('notifications').select("*");

      List<NotificationType> allNotification = notif.map((message) {
        return NotificationType(
            id: message['notification_id'],
            title: message['title'],
            subtitle: message['subtitle'],
            body: message['body'],
            time: message['time'],
            read: message['read'],
            isOpen: message['is_open'],
            notificationKey: message['notification_key'],
            notificationId: message['notification_id']);
      }).toList();

      List filteredMessage = allNotification
          .where((data) => data.notificationKey == message.notificationKey)
          .toList();

      print(filteredMessage);

      if (filteredMessage.isNotEmpty) {
        print('not exist 503');
        return;
      }

      //online
      await Supabase.instance.client.from('notifications').insert({
        'title': message.title,
        'notification_id': message.id,
        'notification_key': message.notificationKey,
        'subtitle': message.subtitle,
        'body': message.body,
        'time': message.time,
        'read': message.read,
        'is_open': message.isOpen
      });

      //caching
      await notificationBox.put(message.notificationKey, message);
      getNotifications();
      notifyListeners();
      print('successfully inserted code 503 notifications');
    } catch (e) {
      print("error code 503 notifications $e");
      //offline
      await notificationBox.put(message.notificationKey, message);
      getNotifications();
      notifyListeners();
    }
  }

  //504
  // event Ennded
  insertEventEndedData(String key, NotificationType message) async {
    try {
      var notif =
          await Supabase.instance.client.from('notifications').select("*");

      List<NotificationType> allNotification = notif.map((message) {
        return NotificationType(
            id: message['notification_id'],
            title: message['title'],
            subtitle: message['subtitle'],
            body: message['body'],
            time: message['time'],
            read: message['read'],
            isOpen: message['is_open'],
            notificationKey: message['notification_key'],
            notificationId: message['notification_id']);
      }).toList();

      List filteredMessage = allNotification
          .where((data) => data.notificationKey == message.notificationKey)
          .toList();

      if (filteredMessage.isNotEmpty) {
        print('not exist 504');
        return;
      }

      //online
      await Supabase.instance.client.from('notifications').insert({
        'title': message.title,
        'notification_id': message.id,
        'notification_key': message.notificationKey,
        'subtitle': message.subtitle,
        'body': message.body,
        'time': message.time,
        'read': message.read,
        'is_open': message.isOpen
      });

      //caching
      await notificationBox.put(message.notificationKey, message);
      getNotifications();
      notifyListeners();
      print('successfully inserted code 504 notifications');
    } catch (e) {
      print("error code 504 notifications $e");
      //offline
      await notificationBox.put(message.notificationKey, message);
      getNotifications();
      notifyListeners();
    }
  }

  //505
  updateMessageRead(String id) async {
    //caching
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
    print('successfully inserted code 505 notifications');
  }

  //506
  deleteNotification(String id) async {
    try {
      notificationBox.delete(id);
      notification_cache.put(id, id);
      getNotifications();
      notifyListeners();
      print('successfully deleted 506');
    } catch (e) {
      print('error 506 delete notification $e');
    }
  }

  //507
  callBackListener() {
    try {
      Supabase.instance.client.from('notifications').stream(
          primaryKey: ['id']).listen((List<Map<String, dynamic>> data) async {
        var notif = data.map((message) {
          return NotificationType(
              id: message['notification_id'],
              title: message['title'],
              subtitle: message['subtitle'],
              body: message['body'],
              time: message['time'],
              read: message['read'],
              isOpen: message['is_open'],
              notificationKey: message['notification_key'],
              notificationId: message['notification_id']);
        }).toList();

        notificationList = notif;
        print('callback');
        notifyListeners();

        var notification_length = await Supabase.instance.client
            .from('notification_length')
            .select("*")
            .eq('id', 101)
            .single();

        var notification_length_data = notification_length['length'];
        var length = notif.length;
        getNotifications();

        if (notification_length_data != length) {
          await Supabase.instance.client
              .from('notification_length')
              .update({'length': length}).eq('id', 101);
          getNotifications();
          Future.delayed(Duration(seconds: 3), () {
            print('notifications updated');
            LocalNotifications.showNotification('New Notifications', '');
          });
          print('equal');
          return;
        }
      });
    } catch (e) {
      print('error 507 notification callback $e');
    }
  }
}
