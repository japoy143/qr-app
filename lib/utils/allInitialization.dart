import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/eventlistattendance.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/eventsid.dart';
import 'package:qr_app/models/notifications.dart';
import 'package:qr_app/models/penaltyvalues.dart';
import 'package:qr_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllInitialization {
  AllDatabaseInit() async {
    //users
    Hive.registerAdapter<UsersType>(UsersTypeAdapter());
    await Hive.openBox<UsersType>('usersBox');

    //events
    Hive.registerAdapter<EventType>(EventTypeAdapter());
    await Hive.openBox<EventType>('eventBox');

    //event attendance
    Hive.registerAdapter<EventAttendance>(EventAttendanceAdapter());
    await Hive.openBox<EventAttendance>("eventAttendanceBox");

    //eventAttendanceList
    Hive.registerAdapter<EventAttendanceList>(EventAttendanceListAdapter());
    await Hive.openBox<EventAttendanceList>('eventAttendanceListBox');

    //eventIds
    Hive.registerAdapter<EventsId>(EventsIdAdapter());
    await Hive.openBox<EventsId>('eventsIdBox');

    //notifications
    Hive.registerAdapter<NotificationType>(NotificationTypeAdapter());
    await Hive.openBox<NotificationType>('notificationBox');

    //notification id container
    await Hive.openBox('notification_cache');

    //session id container
    await Hive.openBox('sessionBox');

    //all penalty values
    Hive.registerAdapter<PenaltyValues>(PenaltyValuesAdapter());
    await Hive.openBox<PenaltyValues>('penaltyBox');

    //isData save
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDatabaseSave', false);
  }
}
