import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/notificationscreen.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/notificationProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/notification_active.dart';
import 'package:qr_app/theme/notification_none.dart';
import 'package:qr_app/utils/homescreenUtils/eventBox.dart';
import 'package:qr_app/utils/homescreenUtils/eventBoxes.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/homescreenUtils/eventEndedBox.dart';

class HomeScreen extends StatefulWidget {
  final String userKey;
  final Function(int index) setIndex;
  const HomeScreen({super.key, required this.userKey, required this.setIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// return profile condition
Widget showProfile(String imagePath, String response, double screenHeight,
    double statusbarHeight) {
  // online and http link is not  empty
  if (response != 'off' && response != '') {
    return CircleAvatar(
      radius: (screenHeight - statusbarHeight) * 0.035,
      backgroundImage:
          NetworkImage(response), // Use NetworkImage for URL-based images
      backgroundColor: Colors.transparent,
    );
  }

  //if offline and has image
  if (response == 'off' && imagePath != '') {
    CircleAvatar(
      radius: (screenHeight - statusbarHeight) * 0.035,
      backgroundImage: FileImage(File(imagePath)),
      backgroundColor: Colors.transparent,
    );
  }
  return Icon(
    Icons.account_circle_outlined,
    size: (screenHeight - statusbarHeight) * 0.07,
  );
}

class _HomeScreenState extends State<HomeScreen> {
  int notification = 1;

  final colortheme = ColorThemeProvider();

  final adminPosition = adminPositions();

  final appBar = AppBar();

  void isSignUpOnlineDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          content: SizedBox(
            width: 150, // Set a fixed width for the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: color,
                  size: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Sign Up Online',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Please Sign Up Your Account Online So That Your Attendance Will Be Saved in the Database',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                    height:
                        20), // Add some spacing between the text and the button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical:
                                      8), // Add padding to the button for better touch area
                              decoration: BoxDecoration(
                                color: color,
                              ),
                              child: const Center(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  checkIfUserSignUpOnline() {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    UsersType user = provider.userData;
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));
    if (user.isSignupOnline) {
      return;
    }

    isSignUpOnlineDialog(context, purple);
  }

  // check if there is internet then use callback
  checkIfThereIsInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      Provider.of<NotificationProvider>(context, listen: false)
          .callBackListener();
      print('online');
    }
  }

  //check if the is internet then save offline data
  saveAllOflineData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final offlineBox = await Hive.box('offlineBox');

    var isDataSave = await offlineBox.get('offline');

    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      if (isDataSave == null && isDataSave) {
        Provider.of<EventAttendanceProvider>(context, listen: false)
            .getOfflineSaveEventAttendance();

        Provider.of<EventIdProvider>(context, listen: false)
            .getOfflineSaveEventId();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).getEvents();

      Provider.of<UsersProvider>(context, listen: false)
          .getUser(widget.userKey);

      Provider.of<UsersProvider>(context, listen: false)
          .getUserImage(widget.userKey);

      checkIfThereIsInternet();

      saveAllOflineData();

      checkIfUserSignUpOnline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    //total height
    double totalHeight = appBarHeight + screenHeight + statusbarHeight;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    return Consumer<EventProvider>(
      builder: (cotext, provider, child) {
        //events list
        List<EventType> event = provider.eventList;

        //sort by date
        event.sort((a, b) => a.eventDate.compareTo(b.eventDate));

        //filter all event ended
        final filterEventEnded =
            event.where((event) => event.eventEnded == false).toList();

        final event1 =
            filterEventEnded.isNotEmpty ? filterEventEnded.elementAt(0) : null;
        final event2 =
            filterEventEnded.length > 1 ? filterEventEnded.elementAt(1) : null;
        final event3 =
            filterEventEnded.length > 2 ? filterEventEnded.elementAt(2) : null;

        // show ended event
        final onlyEventEnded =
            event.where((event) => event.eventEnded == true).toList();

        //first event ended
        final firstEventEnded =
            onlyEventEnded.isNotEmpty ? onlyEventEnded.elementAt(0) : null;

        final user = userProvider.userData;

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
                            Consumer<UsersProvider>(
                                builder: (context, provider, child) {
                              final userImageUrl = provider.userImage;

                              return userImageUrl != null
                                  ? showProfile(user.userProfile, userImageUrl,
                                      screenHeight, statusbarHeight)
                                  : Icon(
                                      Icons.account_circle_outlined,
                                      size: (screenHeight - statusbarHeight) *
                                          0.07,
                                    );
                            }),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    "${user.userName} ${user.lastName}",
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                    '${user.isAdmin ? adminPosition.positions[user.schoolId] : "Student"}'),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NotificationScreen(
                                          screenHeight: totalHeight,
                                        ))),
                            child: Consumer<NotificationProvider>(
                              builder: (context, notificationProvider, child) {
                                //notifications
                                final inbox =
                                    notificationProvider.notificationList;

                                // filter unread notifications
                                final unread = inbox
                                    .where((message) => message.read == false)
                                    .toList();

                                return Container(
                                    child: unread.isNotEmpty
                                        ? const NotificationActive(
                                            height: 26, width: 26)
                                        : const NotificationNone(
                                            height: 26,
                                            width: 26,
                                          ));
                              },
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
                                child: GestureDetector(
                                  onTap: () => widget.setIndex(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Center(
                                        child: event1 != null
                                            ? EventBoxHomescreen(
                                                isAdmin: user.isAdmin,
                                                items: event1,
                                                officerName: user.userName,
                                                userKey: widget.userKey,
                                              )
                                            : Center(
                                                child: Text(
                                                  'No Event',
                                                  style: TextStyle(
                                                      color: colortheme
                                                          .secondaryColor,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                  ),
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
                                child: GestureDetector(
                                  onTap: () => widget.setIndex(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Center(
                                        child: event2 != null
                                            ? EventBoxes(
                                                eventName: event2.eventName,
                                                colorWhite:
                                                    colortheme.secondaryColor,
                                                eventDescription:
                                                    event2.eventDescription,
                                                eventStatus: 'Ongoing',
                                                eventDate: event2.eventDate,
                                              )
                                            : Center(
                                                child: Text(
                                                  'No Event',
                                                  style: TextStyle(
                                                      color: colortheme
                                                          .secondaryColor,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
                                child: GestureDetector(
                                  onTap: () => widget.setIndex(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Center(
                                        child: event3 != null
                                            ? EventBoxes(
                                                eventName: event3.eventName,
                                                colorWhite:
                                                    colortheme.secondaryColor,
                                                eventDescription:
                                                    event3.eventDescription,
                                                eventStatus: 'Ongoing',
                                                eventDate: event3.eventDate,
                                              )
                                            : Center(
                                                child: Text(
                                                  'No Event',
                                                  style: TextStyle(
                                                      color: colortheme
                                                          .secondaryColor,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                  ),
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
                                onTap: () => widget.setIndex(1),
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
                  GestureDetector(
                    onTap: () => widget.setIndex(2),
                    child: Container(
                        decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.circular(4.0)),
                        height: (screenHeight - statusbarHeight) * 0.24,
                        child: Column(
                          children: [
                            Expanded(
                                child: firstEventEnded != null
                                    ? EventEndedBoxHomescreen(
                                        isAdmin: user.isAdmin,
                                        items: firstEventEnded,
                                        officerName: user.userName,
                                        userKey: widget.userKey,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () => widget.setIndex(2),
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
          ),
        );
      },
    );
  }
}
