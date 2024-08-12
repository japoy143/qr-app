import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/services/eventdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:qr_app/utils/allInitialization.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

//work manager initialization
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final _eventDB = EventDatabase();
    switch (task) {
      case 'updateEvent':
        _eventDB.UpdateEvent(inputData!['id']);
        print('event Updated');
        break;

      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  //all db init
  final _allInit = AllInitialization();

  // all hive database initialization for hive boxes user, event ...
  _allInit.AllDatabaseInit();

  //notification
  tz.initializeTimeZones();
  await LocalNotifications.init();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
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
