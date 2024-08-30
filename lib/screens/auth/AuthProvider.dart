import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/screens/menuscreen.dart';
import 'package:qr_app/state/usersProvider.dart';

class AuthProvider extends StatefulWidget {
  const AuthProvider({super.key});

  @override
  State<AuthProvider> createState() => _AuthProviderState();
}

class _AuthProviderState extends State<AuthProvider> {
  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        final user = provider.userData;
        final status = user.isLogin;

        if (status) {
          print(status.toString());
          return const MenuScreen();
        } else {
          return const LandingScreen();
        }
      },
    );
  }
}
