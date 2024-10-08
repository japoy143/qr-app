import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/notifications.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/notificationProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:qr_app/utils/userscreenUtils/scanner.dart';

class EventBoxHomescreen extends StatefulWidget {
  final EventType items;
  final bool isAdmin;
  final String userKey;
  final String officerName;

  EventBoxHomescreen(
      {super.key,
      required this.isAdmin,
      required this.items,
      required this.userKey,
      required this.officerName});

  @override
  _EventBoxHomescreenState createState() => _EventBoxHomescreenState();
}

class _EventBoxHomescreenState extends State<EventBoxHomescreen> {
  late Timer _timer;
  late String _eventStatus;
  late EventType item;

  bool isOngoingNotificationShown = true;
  bool isEventNotificationShown = true;

  //color
  final colorTheme = ColorThemeProvider();

  @override
  void initState() {
    item = widget.items;
    super.initState();
    _eventStatus = showEventStatus(item.startTime, item.endTime);
    _startTimer();
  }

  //notifications
  final notifications = LocalNotifications();

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _eventStatus = showEventStatus(item.startTime, item.endTime);
        if (DateTime.now().isAfter(item.endTime)) {
          _timer.cancel();
        }
      });
    });
  }

  String showEventStatus(DateTime date, DateTime event_end) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    DateTime now = DateTime.now();

    if (now.isAtSameMomentAs(event_end) || now.isAfter(event_end)) {
      if (isEventNotificationShown) {
        LocalNotifications.showNotification(
            'Event Status', 'Event ended attendance is not available');

        //ensure once
        isEventNotificationShown = false;
      }

      String eventName = item.eventName;
      String id = item.id.toString();

      eventProvider.updateEventEndedData(item.id);
      notificationProvider.insertEventEndedData(
          '$id-ended',
          NotificationType(
              id: item.id,
              title: 'Event Ended',
              subtitle: item.eventName,
              body:
                  ' $eventName is already ended. attendance is already close ',
              time: item.endTime.toString(),
              read: false,
              isOpen: false));

      return 'Event Ended';
    }

    if (now.isAtSameMomentAs(date) || now.isAfter(date)) {
      if (isOngoingNotificationShown) {
        LocalNotifications.showNotification('Event Status',
            'Event Ongoing please go to the ${item.eventPlace}');

        //ensure once
        isOngoingNotificationShown = false;
      }
      return 'Ongoing';
    } else {
      String formattedDate = DateFormat("h:mm a").format(date);
      return formattedDate;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM d').format(item.eventDate);
    List splittedDate = formattedDate.split(" ");

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 14, 14.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.eventName,
                style: TextStyle(
                  color: colorTheme.secondaryColor,
                  fontFamily: "Poppins",
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              widget.isAdmin
                  ? _eventStatus == "Ongoing"
                      ? GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QrCodeScanner(
                                        EventId: item.id,
                                        userKey: widget.userKey,
                                        officerName: widget.officerName,
                                        EventName: item.eventName,
                                      ))),
                          child: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 26,
                          ),
                        )
                      : SizedBox.shrink()
                  : SizedBox.shrink()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  item.eventDescription,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontFamily: "Poppins",
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.eventPlace,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontFamily: "Poppins",
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14.0, 0, 0),
                    child: Text(
                      _eventStatus,
                      style: TextStyle(
                        color: colorTheme.secondaryColor,
                        fontFamily: "Poppins",
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    splittedDate[0],
                    style: TextStyle(
                      color: colorTheme.secondaryColor,
                      fontFamily: "Poppins",
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    splittedDate[1],
                    style: TextStyle(
                      color: colorTheme.secondaryColor,
                      fontFamily: "Poppins",
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
