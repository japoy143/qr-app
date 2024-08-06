import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/positions.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/theme/notification_active.dart';
import 'package:qr_app/theme/notification_none.dart';
import 'package:qr_app/utils/homescreenUtils/eventBox.dart';
import 'package:qr_app/utils/homescreenUtils/eventBoxes.dart';
import 'package:qr_app/services/eventdatabase.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';

class HomeScreen extends StatefulWidget {
  final String userKey;
  final Function()? setIndex;
  const HomeScreen({super.key, required this.userKey, required this.setIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notification = 1;

  final eventDb = EventDatabase();
  final userDb = UsersDatabase();
  late Box<EventType> _eventBox;
  late Box<UsersType> _userBox;
  final colortheme = ColorThemeProvider();

  final adminPosition = adminPositions();

  final appBar = AppBar();

  @override
  void initState() {
    _eventBox = eventDb.EventDatabaseInitialization();
    _userBox = userDb.UsersDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    //events list
    List<EventType> event = _eventBox.values.toList();

    //sort by date
    event.sort((a, b) => a.eventDate.compareTo(b.eventDate));

    //filter all event ended
    final filterEventEnded = event.where((event) => event.eventEnded == false);

    final event1 = filterEventEnded.isNotEmpty ? event.elementAt(0) : null;
    final event2 = filterEventEnded.length > 1 ? event.elementAt(1) : null;
    final event3 = filterEventEnded.length > 2 ? event.elementAt(2) : null;

    final userDetails = _userBox.get(widget.userKey);
    final userName = userDetails!.userName;
    final userSchoolId = userDetails.schoolId;
    final isAdmin = userDetails.isAdmin;
    final userProfile = userDetails.userProfile;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 0, 14, 0),
          child: Column(
            children: [
              SizedBox(
                height: (screenHeight - statusbarHeight) * 0.12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        userProfile == ""
                            ? Icon(
                                Icons.account_circle_outlined,
                                size: (screenHeight - statusbarHeight) * 0.07,
                              )
                            : CircleAvatar(
                                radius:
                                    (screenHeight - statusbarHeight) * 0.035,
                                backgroundImage: FileImage(File(userProfile)),
                                backgroundColor: Colors.transparent,
                              ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                userName,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                                '${isAdmin ? adminPosition.positions[userSchoolId] : "Student"}'),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Container(
                        child: notification != 0
                            ? const NotificationActive(height: 26, width: 26)
                            : const NotificationNone(
                                height: 26,
                                width: 26,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Events',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade400,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: (screenHeight - statusbarHeight) * 0.40,
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Center(
                                  child: event1 != null
                                      ? EventBoxHomescreen(
                                          isAdmin: isAdmin,
                                          item: event1,
                                        )
                                      : Center(
                                          child: Text(
                                            'No Event',
                                            style: TextStyle(
                                                color:
                                                    colortheme.secondaryColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Center(
                                  child: event2 != null
                                      ? EventBoxes(
                                          eventName: event2.eventName,
                                          colorWhite: colortheme.secondaryColor,
                                          eventDescription:
                                              event2.eventDescription,
                                          eventStatus: 'Ongoing',
                                          eventDate: event2.eventDate,
                                        )
                                      : Center(
                                          child: Text(
                                            'No Event',
                                            style: TextStyle(
                                                color:
                                                    colortheme.secondaryColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Center(
                                  child: event3 != null
                                      ? EventBoxes(
                                          eventName: event3.eventName,
                                          colorWhite: colortheme.secondaryColor,
                                          eventDescription:
                                              event3.eventDescription,
                                          eventStatus: 'Ongoing',
                                          eventDate: event3.eventDate,
                                        )
                                      : Center(
                                          child: Text(
                                            'No Event',
                                            style: TextStyle(
                                                color:
                                                    colortheme.secondaryColor,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: GestureDetector(
                            onTap: widget.setIndex,
                            child: Text(
                              'See More',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Event',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Summary',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey.shade400,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      color: purple, borderRadius: BorderRadius.circular(4.0)),
                  height: (screenHeight - statusbarHeight) * 0.24,
                  child: Column(
                    children: [
                      Expanded(
                          child: event1 != null
                              ? EventBoxHomescreen(
                                  isAdmin: isAdmin,
                                  item: event1,
                                )
                              : Center(
                                  child: Text(
                                    'No Event',
                                    style: TextStyle(
                                        color: colortheme.secondaryColor,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Text(
                      'See More',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
