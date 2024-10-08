import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/notifications.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/notificationscreen.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/notificationProvider.dart';
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
  String currentDate = '';
  String currentTime = '';
  String eventTimeEnd = '';

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getEvents();
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotifications();
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
            isOpen: false));

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
    final userDetails = userProvider.getUser(widget.userKey);
    final userName = userDetails!.userName;
    final userSchoolId = userDetails.schoolId;
    final isAdmin = userDetails.isAdmin;
    final userProfile = userDetails.userProfile;

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        //events
        List<EventType> allEvents = provider.eventList;

        //sort by date
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
                          Row(
                            children: [
                              userProfile == ""
                                  ? Icon(
                                      Icons.account_circle_outlined,
                                      size: (screenHeight - statusbarHeight) *
                                          0.07,
                                    )
                                  : CircleAvatar(
                                      radius: (screenHeight - statusbarHeight) *
                                          0.035,
                                      backgroundImage:
                                          FileImage(File(userProfile)),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => NotificationScreen(
                                          screenHeight: screenHeight))),
                              child: Consumer<NotificationProvider>(
                                builder:
                                    (context, notificationProvider, child) {
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
                                          ),
                                  );
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
                    Expanded(
                        child: ListView.builder(
                            itemCount: sortedEventNotEnded.length,
                            itemBuilder: (context, index) {
                              final item = sortedEventNotEnded.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          backgroundColor: Colors.redAccent,
                                          onPressed: (context) {
                                            setState(() {
                                              provider.deleteEvent(item.id);
                                            });
                                          },
                                          icon: Icons.delete,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        )
                                      ]),
                                  child: Container(
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: EventBox(
                                      officerName: userName,
                                      updateEvent: () => showDialogUpdate(
                                          (screenHeight - statusbarHeight) *
                                              0.68,
                                          screenWidth * 0.85,
                                          purple,
                                          item,
                                          totalHeight),
                                      items: item,
                                      userkey: widget.userKey,
                                      isAdmin: isAdmin,
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            ),
            floatingActionButton: isAdmin
                ? FloatingActionButton(
                    onPressed: () => showAddEvent(
                      (screenHeight - statusbarHeight) * 0.68,
                      screenWidth * 0.85,
                      purple,
                      totalHeight,
                    ),
                    child: Icon(Icons.add),
                  )
                : null);
      },
    );
  }
}
