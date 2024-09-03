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

  //err code 5**

  //500
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

      notificationList = allMessages;
      notifyListeners();
      print('successfully get code 500 notifications');
    } catch (e) {
      print('error code 500 notifications $e');
      var data = notificationBox.values.toList();
      notificationList = data;
      notifyListeners();
    }
  }

  //501
  //get event specific event
  bool containsEvent(int id) {
    var event = notificationBox.containsKey(id);
    return event;
  }

  //502
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
        print('not exist 502');
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
      await notificationBox.put(id, message);
      getNotifications();
      notifyListeners();
      print('successfully inserted code 502 notifications');
    } catch (e) {
      print("error code 502 notifications $e");
      //offline
      await notificationBox.put(id, message);
      getNotifications();
      notifyListeners();
    }
  }

  //503
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
      await notificationBox.put(key, message);
      getNotifications();
      notifyListeners();
      print('successfully inserted code 503 notifications');
    } catch (e) {
      print("error code 503 notifications $e");
      //offline
      await notificationBox.put(key, message);
      getNotifications();
      notifyListeners();
    }
  }

  //504
  updateMessageRead(int id) async {
    try {
      //online
      // update message read
      await Supabase.instance.client
          .from('notifications')
          .update({'read': true}).eq('notification_id', id);

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
      print('successfully inserted code 504 notifications');
    } catch (e) {
      print("error code 504 notifications $e");
      //offline
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
  }

  //505
  deleteNotification(int id) async {
    try {
      await Supabase.instance.client
          .from('notifications')
          .delete()
          .eq('notification_id', id);

      notificationBox.delete(id);
      getNotifications();
      notifyListeners();
      print('successfully delete 505 notifications');
    } catch (e) {
      print('error delete 505 notifications $e');
      notificationBox.delete(id);
      getNotifications();
      notifyListeners();
    }
  }

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

        if (notification_length_data == length) {
          print('equal');
          return;
        }

        await Supabase.instance.client
            .from('notification_length')
            .update({'length': length}).eq('id', 101);

        Future.delayed(Duration(seconds: 3), () {
          print('notifications updated');
          LocalNotifications.showNotification('New Notifications', '');
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
