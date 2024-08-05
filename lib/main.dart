import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:qr_app/utils/localNotifications.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  //users
  Hive.registerAdapter<UsersType>(UsersTypeAdapter());
  await Hive.openBox<UsersType>('usersBox');

  //events
  Hive.registerAdapter<EventType>(EventTypeAdapter());
  await Hive.openBox<EventType>('_eventBox');

  //event attendance
  Hive.registerAdapter<EventAttendance>(EventAttendanceAdapter());
  await Hive.openBox("eventAttendanceBox");

  //notification
  tz.initializeTimeZones();
  await LocalNotifications.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorThemeProvider();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(color.hexColor(color.primaryColor))),
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
