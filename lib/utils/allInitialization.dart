import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/eventlistattendance.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/eventsid.dart';
import 'package:qr_app/models/users.dart';

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
  }
}
