import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/eventscreen.dart';
import 'package:qr_app/screens/homescreen.dart';
import 'package:qr_app/screens/eventsummaryscreen.dart';
import 'package:qr_app/screens/penaltyscreen.dart';
import 'package:qr_app/screens/userscreen.dart';
import 'package:qr_app/screens/validationscreen.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final UsersType user;
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
    user = Provider.of<UsersProvider>(context, listen: false).userData;
    Provider.of<UsersProvider>(context, listen: false)
        .getUser(user.schoolId.toString());
    Provider.of<UsersProvider>(context, listen: false)
        .getUserImage(user.schoolId.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final userDetails = userProvider.userData;
    final isAdmin = userDetails.isAdmin;
    final validation = userDetails.isValidationRep;

    List pages = isAdmin
        ? [
            HomeScreen(
              user: user,
              setIndex: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            EventScreen(
              userKey: user.schoolId.toString(),
            ),
            EventSummaryScreen(
              userKey: user.schoolId.toString(),
            ),
            const PenaltyScreen(),
            UserScreen(
              userKey: user.schoolId.toString(),
            )
          ]
        : [
            HomeScreen(
              user: user,
              setIndex: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            EventScreen(
              userKey: user.schoolId.toString(),
            ),
            EventSummaryScreen(
              userKey: user.schoolId.toString(),
            ),
            validation
                ? ValidationScreen(userKey: user.schoolId.toString())
                : UserScreen(
                    userKey: user.schoolId.toString(),
                  ),
            UserScreen(
              userKey: user.schoolId.toString(),
            ),
          ];

    List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined), label: 'Event Summary'),
      if (isAdmin)
        const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined), label: 'Penalty'),
      if (!isAdmin && validation)
        const BottomNavigationBarItem(
            icon: Icon(Icons.verified_user_sharp), label: 'Validation'),
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
