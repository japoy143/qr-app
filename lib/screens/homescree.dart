import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/screens/homescreenUtils/eventBoxes.dart';
import 'package:qr_app/screens/homescreenUtils/eventbox.dart';
import 'package:qr_app/screens/homescreenUtils/pastevent.dart';
import 'package:qr_app/services/eventdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notification = 1;

  final eventDb = EventDatabase();
  late Box<EventType> _eventBox;
  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    _eventBox = eventDb.EventDatabaseInitialization();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    Iterable<EventType> event = _eventBox.values.toList().reversed;
    final event1 = event.elementAt(0);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0, 14, 0),
        child: SafeArea(
            child: Column(
          children: [
            Container(
              height: (screenHeight - statusbarHeight) * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colortheme.secondaryColor,
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: (screenHeight - statusbarHeight) * 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jane'),
                          Text('LSG Officer'),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                      backgroundColor: colortheme.secondaryColor,
                      child: Image.asset(notification != 0
                          ? 'assets/imgs/isnotified.png'
                          : 'assets/imgs/notified.png'))
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
            Container(
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
                                child: EventBox(
                              eventName: event1.eventName,
                              colorWhite: colortheme.secondaryColor,
                              eventDescription: event1.eventDescription,
                              eventStatus: 'Ongoing',
                              eventDate: event1.eventDate,
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
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                          child: Container(
                            decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Center(
                                child: EventBoxes(
                              eventName: event1.eventName,
                              colorWhite: colortheme.secondaryColor,
                              eventDescription: event1.eventDescription,
                              eventStatus: 'Ongoing',
                              eventDate: event1.eventDate,
                            )),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
                          child: Container(
                            decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Center(
                                child: EventBoxes(
                              eventName: event1.eventName,
                              colorWhite: colortheme.secondaryColor,
                              eventDescription: event1.eventDescription,
                              eventStatus: 'Ongoing',
                              eventDate: event1.eventDate,
                            )),
                          ),
                        )),
                      ],
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
                    Text(
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
              height: (screenHeight - statusbarHeight) * 0.28,
              child: PastEventBox(
                  eventName: event1.eventName,
                  colorWhite: colortheme.secondaryColor,
                  eventDescription: event1.eventDescription,
                  eventStatus: 'sdada',
                  eventDate: event1.eventDate),
            ),
          ],
        )),
      ),
    );
  }
}
