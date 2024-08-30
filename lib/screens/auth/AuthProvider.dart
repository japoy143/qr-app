import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/screens/menuscreen.dart';
import 'package:qr_app/state/usersProvider.dart';
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
    Provider.of<UsersProvider>(context, listen: false).userData;
    initSharedPref();
    super.initState();
  }

  Future<void> initSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtainedId = prefs.getInt('school_id');

    if (obtainedId == null) {
      prefs.setInt('school_id', 0);
    }
    setState(() {
      userKey = obtainedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        if (userKey != null) {
          provider.getUser(userKey.toString());
          print(userKey);
        }

        final user = provider.userData;
        final status = user.isLogin;

        print(status);

        if (status) {
          return const MenuScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
