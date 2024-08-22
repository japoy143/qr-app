import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:qr_app/utils/allInitialization.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for notifications
  await Permission.notification.request();

  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  //all db init
  final _allInit = AllInitialization();

  // all hive database initialization for hive boxes user, event ...
  _allInit.AllDatabaseInit();

  //notification
  tz.initializeTimeZones();
  await LocalNotifications.init();

  //all providers
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => EventProvider()),
    ChangeNotifierProvider(create: (context) => EventAttendanceProvider()),
    ChangeNotifierProvider(create: (context) => EventIdProvider()),
    ChangeNotifierProvider(create: (context) => UsersProvider())
  ], child: const MyApp()));
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
