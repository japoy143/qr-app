import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/notifications.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/screens/notificationscreen.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/notificationProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/theme/notification_active.dart';
import 'package:qr_app/theme/notification_none.dart';
import 'package:qr_app/utils/eventscreenUtils/addEventModal.dart';
import 'package:qr_app/utils/eventscreenUtils/eventbox.dart';
import 'package:qr_app/utils/eventscreenUtils/formatters.dart';
import 'package:qr_app/utils/eventscreenUtils/updateEvent.dart';
import 'package:qr_app/utils/toast.dart';

class EventScreen extends StatefulWidget {
  final String userKey;
  const EventScreen({super.key, required this.userKey});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final colortheme = ColorThemeProvider();

  //admin positions || role
  final adminPosition = adminPositions();

  //notification
  int notification = 1;

  //now
  DateTime now = DateTime.now();

  //toast
  final toast = CustomToast();

  //utils, functions and formatter
  final formatter = EventScreentFormatterUtils();

  //controllers
  var _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventPlaceController = TextEditingController();
  final _eventIdController = TextEditingController();
  final _eventPenaltyController = TextEditingController();
  String currentDate = '';
  String currentTime = '';
  String eventTimeEnd = '';

  // check if there is internet then use callback
  checkIfThereIsInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      Provider.of<EventProvider>(context, listen: false).callBackListener();
      print('online');
    }
  }

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getEvents();

    Provider.of<NotificationProvider>(context, listen: false)
        .getNotifications();

    Provider.of<UsersProvider>(context, listen: false).getUser(widget.userKey);

    try {
      Provider.of<EventProvider>(context, listen: false).callBackListener();
    } catch (e) {}

    super.initState();
  }

  void updateEventDetails(String newDate, String newTime, String newEndTime) {
    setState(() {
      currentDate = newDate;
      currentTime = newTime;
      eventTimeEnd = newEndTime;
    });
  }

  void clearFields() {
    _eventNameController.clear();
    _eventPlaceController.clear();
    _eventDescriptionController.clear();
    _eventIdController.clear();
    _eventPenaltyController.clear();
    currentDate = '';
    currentTime = '';
    eventTimeEnd = '';
    Navigator.of(context).pop();
  }

  //modal for adding event
  void showAddEvent(
      double height, double width, Color color, double screenHeight) {
    showDialog(
        context: context,
        builder: (context) {
          return addEventDialog(
            eventPenalty: _eventPenaltyController,
            screenHeight: screenHeight,
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
            onSave: addEvent,
            onCancel: clearFields,
            onUpdateEventDetails: updateEventDetails,
          );
        });
  }

  String dateFormatterForNotif(String time) {
    DateTime convertStringTime = DateTime.parse(time);
    String monthAndDay = DateFormat('MMM d').format(convertStringTime);
    String hour = DateFormat('h:mm a').format(convertStringTime);
    String formattedDate = "$monthAndDay  $hour";

    return formattedDate;
  }

  void addEvent() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    //form validate
    if (_eventIdController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty ||
        _eventNameController.text.isEmpty ||
        _eventPlaceController.text.isEmpty) {
      toast.errorCreationEvent(context);
      return;
    }

    //ensure event id is unique
    if (eventProvider.containsEvent(int.parse(_eventIdController.text))) {
      toast.errorEventIdAlreadyUsed(context);
      print('contains');
      return;
    }

    // ensure eventTime must be before
    if (formatter.ensureEventTimeIsBeforeThanEventEnd(
        context, currentTime, eventTimeEnd)) {
      toast.errorEventEnd(context);
      return;
    }

    //insert event
    eventProvider.insertData(EventType(
        eventPenalty: int.parse(_eventPenaltyController.text),
        id: int.parse(_eventIdController.text),
        eventName: _eventNameController.text,
        eventDescription: _eventDescriptionController.text,
        eventDate: formatter.dateFormmater(currentDate, currentTime),
        startTime: formatter.dateFormmater(currentDate, currentTime),
        eventPlace: _eventPlaceController.text,
        key: _eventIdController.text,
        endTime: formatter.dateFormmater(currentDate, eventTimeEnd),
        eventEnded: false));

    String eventDescription = _eventDescriptionController.text;
    String eventPlace = _eventPlaceController.text;
    String eventTime =
        formatter.dateFormmater(currentDate, currentTime).toString();
    String formattedDate = dateFormatterForNotif(eventTime);

    int notificationId = int.parse(_eventIdController.text);
    String notificationKey = "$notificationId-new";

    //add notification
    notificationProvider.insertData(
        int.parse(_eventIdController.text),
        NotificationType(
            id: int.parse(_eventIdController.text),
            title: 'New Event!',
            subtitle: _eventNameController.text,
            body:
                '$eventDescription will be held in $eventPlace  at  $formattedDate ',
            time: DateTime.now().toString(),
            read: false,
            isOpen: false,
            notificationKey: notificationKey,
            notificationId: notificationId));

    formatter.dateFormmater(currentTime, eventTimeEnd);

    //clear
    clearFields();
    setState(() {});
  }

//update
  void showDialogUpdate(double height, double width, Color color,
      EventType item, double screenHeight) {
    setState(() {
      currentDate = item.eventDate.toString();
      currentTime = item.startTime.toString();
      eventTimeEnd = item.endTime.toString();
      _eventNameController.text = item.eventName;
      _eventDescriptionController.text = item.eventDescription;
      _eventPlaceController.text = item.eventPlace;
      _eventIdController.text = item.id.toString();
      _eventPenaltyController.text = item.eventPenalty.toString();
    });
    showDialog(
        context: context,
        builder: (context) {
          return UpdateEventDialog(
            screenHeight: screenHeight,
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
            onSave: () => updateEvent(item.id),
            onCancel: clearFields,
            onUpdateEventDetails: updateEventDetails,
            eventPenalty: _eventPenaltyController,
          );
        });
  }

  void updateEvent(int id) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    //form validate
    if (_eventIdController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty ||
        _eventNameController.text.isEmpty ||
        _eventPlaceController.text.isEmpty) {
      toast.errorCreationEvent(context);
      return;
    }

    // ensure eventTime must be before
    if (formatter.ensureEventTimeIsBeforeThanEventEnd(
        context, currentTime, eventTimeEnd)) {
      toast.errorEventEnd(context);
      return;
    }

    setState(() {
      eventProvider.updateEvent(
          id,
          EventType(
              eventPenalty: int.parse(_eventPenaltyController.text),
              id: int.parse(_eventIdController.text),
              eventName: _eventNameController.text,
              eventDescription: _eventDescriptionController.text,
              eventDate: formatter.dateFormmater(currentDate, currentTime),
              startTime: formatter.dateFormmater(currentDate, currentTime),
              eventPlace: _eventPlaceController.text,
              key: _eventIdController.text,
              endTime: formatter.dateFormmater(currentDate, eventTimeEnd),
              eventEnded: false));
    });

    clearFields();
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

  //delete dialog
  void DeleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 240,
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_outlined,
                    size: 40,
                    color: Colors.deepPurpleAccent,
                  ),
                  const Text(
                    'Warning it will clear all data',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'are you sure you want to clear all data ?',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final notificationProvider =
                                Provider.of<NotificationProvider>(context,
                                    listen: false);
                            final userProvider = Provider.of<UsersProvider>(
                                context,
                                listen: false);

                            final eventIdProvider =
                                Provider.of<EventIdProvider>(context,
                                    listen: false);

                            final eventAttendanceProvider =
                                Provider.of<EventAttendanceProvider>(context,
                                    listen: false);
                            final eventProvider = Provider.of<EventProvider>(
                                context,
                                listen: false);

                            await userProvider.deleteAllUsers();
                            await notificationProvider.deleteAllNotifications();
                            await notificationProvider
                                .updateNotificationLength();
                            await eventIdProvider.deleteAllEventId();
                            await eventIdProvider.deleteAllEventIdExtras();
                            await eventAttendanceProvider
                                .deleteAllEventAttendance();
                            await eventAttendanceProvider
                                .deleteAllEventAttendanceExtras();
                            await eventProvider.deleteAllEvent();

                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Text(
                                'Clear Data',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  final appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    //screen queries
    double appBarHeight = appBar.preferredSize.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    double totalHeight = (screenHeight + statusbarHeight + appBarHeight);

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    //user details
    final user = userProvider.userData;
    // final userName = user.userName;
    // final userSchoolId = user.schoolId;
    // final isAdmin = user.isAdmin;
    // final userProfile = user.userProfile;

    //online profile url
    final userImageUrl = userProvider.userImage;

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        //events
        List<EventType> allEvents = provider.eventList;

        allEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));

        //filter event ended
        final sortedEventNotEnded =
            allEvents.where((event) => event.eventEnded == false).toList();
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
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Consumer<UsersProvider>(
                                      builder: (context, provider, child) {
                                    final userImageUrl = provider.userImage;

                                    return userImageUrl != null
                                        ? showProfile(
                                            user.userProfile,
                                            userImageUrl,
                                            screenHeight,
                                            statusbarHeight)
                                        : Icon(
                                            Icons.account_circle_outlined,
                                            size: (screenHeight -
                                                    statusbarHeight) *
                                                0.07,
                                          );
                                  }),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Text(
                                            "${user.userName} ${user.lastName}",
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Text(
                                          '${user.isAdmin ? adminPosition.positions[user.schoolId] : "Student"}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(
                                              screenHeight: totalHeight,
                                            ))),
                                child: Consumer<NotificationProvider>(
                                  builder:
                                      (context, notificationProvider, child) {
                                    //notifications
                                    final inbox =
                                        notificationProvider.notificationList;

                                    // filter unread notifications
                                    final unread = inbox
                                        .where(
                                            (message) => message.read == false)
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
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                        user.schoolId == 900009
                            ? GestureDetector(
                                onTap: () async {
                                  DeleteDialog();
                                },
                                child: Icon(Icons.delete_outline))
                            : SizedBox.shrink(),
                      ],
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: sortedEventNotEnded.length,
                            itemBuilder: (context, index) {
                              final item = sortedEventNotEnded.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                                child: user.isAdmin
                                    ? Slidable(
                                        endActionPane: ActionPane(
                                            motion: const StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                onPressed: (context) {
                                                  setState(() {
                                                    provider
                                                        .deleteEvent(item.id);
                                                  });
                                                },
                                                icon: Icons.delete,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              )
                                            ]),
                                        child: Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                              color: purple,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          child: EventBox(
                                            officerName: user.userName,
                                            updateEvent: () => showDialogUpdate(
                                                (screenHeight -
                                                        statusbarHeight) *
                                                    0.68,
                                                screenWidth * 0.85,
                                                purple,
                                                item,
                                                totalHeight),
                                            items: item,
                                            userkey: widget.userKey,
                                            isAdmin: user.isAdmin,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                            color: purple,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: EventBox(
                                          officerName: user.userName,
                                          updateEvent: () => showDialogUpdate(
                                              (screenHeight - statusbarHeight) *
                                                  0.68,
                                              screenWidth * 0.85,
                                              purple,
                                              item,
                                              totalHeight),
                                          items: item,
                                          userkey: widget.userKey,
                                          isAdmin: user.isAdmin,
                                        ),
                                      ),
                              );
                            })),
                  ],
                ),
              ),
            ),
            floatingActionButton: user.isAdmin
                ? FloatingActionButton(
                    onPressed: () => showAddEvent(
                      (screenHeight - statusbarHeight) * 0.68,
                      screenWidth * 0.85,
                      purple,
                      totalHeight,
                    ),
                    child: const Icon(Icons.add),
                  )
                : null);
      },
    );
  }
}
