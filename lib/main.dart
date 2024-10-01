import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/auth/AuthProvider.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/notificationProvider.dart';
import 'package:qr_app/state/penaltyValues.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:qr_app/utils/allInitialization.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for notifications
  await Permission.notification.request();
  //env
  await dotenv.load(fileName: "assets/.env");
  final String? key = dotenv.env["anon_key"];

  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  //all db init
  final _allInit = AllInitialization();

  // all hive database initialization for hive boxes user, event ...
  await _allInit.AllDatabaseInit();

  //notification
  tz.initializeTimeZones();
  await LocalNotifications.init();

  //supabase initialization
  try {
    supabaseInitialization(key);
    print('supabase initialize');
  } catch (err) {
    print('no internet $err');
  }

  //all providers
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => EventProvider()),
    ChangeNotifierProvider(create: (context) => EventAttendanceProvider()),
    ChangeNotifierProvider(create: (context) => EventIdProvider()),
    ChangeNotifierProvider(create: (context) => UsersProvider()),
    ChangeNotifierProvider(create: (context) => NotificationProvider()),
    ChangeNotifierProvider(create: (context) => PenaltyValuesProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorThemeProvider();
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CITECODE',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(color.hexColor(color.primaryColor))),
          useMaterial3: true,
        ),
        home: const AuthProvider(),
      ),
    );
  }
}

// supabase
Future<void> supabaseInitialization(String? key) async {
  if (key != null) {
    await Supabase.initialize(
        url: 'https://ldgsikvhqduvvndjtyrf.supabase.co', anonKey: key);
  } else {
    print('key is null');
  }
}
