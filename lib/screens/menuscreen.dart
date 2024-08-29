import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/screens/eventscreen.dart';
import 'package:qr_app/screens/homescreen.dart';
import 'package:qr_app/screens/eventsummaryscreen.dart';
import 'package:qr_app/screens/penaltyscreen.dart';
import 'package:qr_app/screens/userscreen.dart';
import 'package:qr_app/state/usersProvider.dart';
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
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUser(widget.userKey);
    Provider.of<UsersProvider>(context, listen: false)
        .getUserImage(widget.userKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final userDetails = userProvider.userData;
    final isAdmin = userDetails.isAdmin;

    List pages = isAdmin
        ? [
            HomeScreen(
              userKey: widget.userKey,
              setIndex: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            EventScreen(
              userKey: widget.userKey,
            ),
            EventSummaryScreen(
              userKey: widget.userKey,
            ),
            const PenaltyScreen(),
            UserScreen(
              userKey: widget.userKey,
            )
          ]
        : [
            HomeScreen(
              userKey: widget.userKey,
              setIndex: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            EventScreen(
              userKey: widget.userKey,
            ),
            EventSummaryScreen(
              userKey: widget.userKey,
            ),
            UserScreen(
              userKey: widget.userKey,
            )
          ];

    List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined), label: 'Event Summary'),
      if (isAdmin)
        const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined), label: 'Penalty Screen'),
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
