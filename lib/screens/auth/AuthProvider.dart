import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/screens/menuscreen.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends StatefulWidget {
  const AuthProvider({super.key});

  @override
  State<AuthProvider> createState() => _AuthProviderState();
}

class _AuthProviderState extends State<AuthProvider> {
  int? userKey;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  Future<void> initSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtainedId = prefs.getInt('school_id');

    if (obtainedId == null) {
      await prefs.setInt('school_id', 0);
      obtainedId = 0;
    }

    setState(() {
      userKey = obtainedId;
    });

    // Moved provider calls here after the userKey is set
    if (userKey != null && userKey != 0) {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      provider.getUser(userKey!.toString());
      provider.getUserImage(userKey.toString());
    }
  }

  final colortheme = ColorThemeProvider();

  @override
  Widget build(BuildContext context) {
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        if (userKey == null) {
          // You can show a loading indicator or splash screen here
          return Center(
              child: Text(
            'LSG',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              color: purple,
              fontSize: 20.0,
            ),
          ));
        }

        final user = provider.userData;
        final status = user.isLogin;

        if (status) {
          return const MenuScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
