import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/positions.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/services/eventdatabase.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventscreenUtils/addEventModal.dart';
import 'package:qr_app/utils/eventscreenUtils/eventbox.dart';

class EventScreen extends StatefulWidget {
  final String userKey;
  const EventScreen({super.key, required this.userKey});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final colortheme = ColorThemeProvider();

  //user database
  late Box<UsersType> _userBox;
  final userdb = UsersDatabase();

  //events database
  late Box<EventType> _eventBox;
  final eventdb = EventDatabase();

  //admin positions || role
  final adminPosition = adminPositions();

  //notification
  int notification = 1;

  //controllers
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventPlaceController = TextEditingController();
  final _eventIdController = TextEditingController();
  DateTime currentDate = DateTime.now();
  DateTime currentTime = DateTime.now();
  DateTime eventTimeEnd = DateTime.now();

  @override
  void initState() {
    _userBox = userdb.UsersDatabaseInitialization();
    _eventBox = eventdb.EventDatabaseInitialization();
    super.initState();
  }

  void showAddEvent(double height, double width, Color color) {
    showDialog(
        context: context,
        builder: (context) {
          return addEventDialog(
            eventTimeEnd: eventTimeEnd,
            currentDate: currentDate,
            currentTime: currentTime,
            color: color,
            height: height,
            width: width,
            eventNameController: _eventNameController,
            eventDescription: _eventDescriptionController,
            eventPlaceController: _eventPlaceController,
            eventId: _eventIdController,
            onSave: () {},
            onCancel: () => Navigator.of(context).pop(),
         
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //screen queries
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    final userDetails = _userBox.get(widget.userKey);
    final userName = userDetails!.userName;
    final userSchoolId = userDetails.schoolId;
    final isAdmin = userDetails.isAdmin;

    //events
    final allEvents = _eventBox.values.toList();


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 20, 14, 0),
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                              '${isAdmin ? adminPosition.positions[userSchoolId] : "Student"}'),
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
            Expanded(
                child: ListView.builder(
                    itemCount: allEvents.length,
                    itemBuilder: (context, index) {
                      final item = _eventBox.getAt(index);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              color: purple,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: EventBox(
                              eventName: item!.eventName,
                              colorWhite: colortheme.secondaryColor,
                              eventDescription: item.eventDescription,
                              eventStatus: 'dada',
                              eventDate: item.eventDate,
                              isAdmin: isAdmin),
                        ),
                      );
                    }))
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEvent(
            (screenHeight - statusbarHeight) * 0.75,
            screenWIdth * 0.85,
            purple,
           ),
        child: Icon(Icons.add),
      ),
    );
  }
}
