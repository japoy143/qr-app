import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/eventscreen.dart';
import 'package:qr_app/screens/homescreen.dart';
import 'package:qr_app/screens/penaltyscreen.dart';
import 'package:qr_app/screens/userscreen.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';

class MenuScreen extends StatefulWidget {
  final String userKey;
  const MenuScreen({super.key, required this.userKey});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final color = ColorThemeProvider();
  List<Widget> bottomNavIcon = const [
    Icon(Icons.home),
    Icon(Icons.event),
    Icon(Icons.pending_actions),
    Icon(Icons.person_outline)
  ];

  int currentIndex = 0;

  final userDb = UsersDatabase();
  late Box<UsersType> _userBox;

  @override
  void initState() {
    _userBox = userDb.UsersDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = _userBox.get(widget.userKey);
    final isAdmin = userDetails!.isAdmin;

    List pages = [
      HomeScreen(
        userKey: widget.userKey,
        setIndex: () {
          setState(() {
            currentIndex = 1;
          });
        },
      ),
      EventScreen(
        userKey: widget.userKey,
      ),
      PenaltyScreen(),
      UserScreen(
        userKey: widget.userKey,
      )
    ];

    List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
      if (isAdmin)
        const BottomNavigationBarItem(
            icon: Icon(Icons.pending), label: 'Penalty'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline), label: 'User'),
    ];
    Color purple = Color(color.hexColor(color.primaryColor));
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        items: bottomNavItems,
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
      ),
    );
  }
}
