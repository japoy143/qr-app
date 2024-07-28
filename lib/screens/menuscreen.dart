import 'package:flutter/material.dart';
import 'package:qr_app/screens/eventscreen.dart';
import 'package:qr_app/screens/homescreen.dart';
import 'package:qr_app/screens/penaltyscreen.dart';
import 'package:qr_app/screens/userscreen.dart';
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

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomeScreen(
        userKey: widget.userKey,
      ),
      EventScreen(),
      PenaltyScreen(),
      UserScreen()
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.pending), label: 'Penalty'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'User'),
        ],
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
      ),
    );
  }
}
