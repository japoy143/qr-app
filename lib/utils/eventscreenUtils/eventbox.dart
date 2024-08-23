import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/localNotifications.dart';
import 'package:qr_app/utils/userscreenUtils/scanner.dart';

class EventBox extends StatefulWidget {
  final EventType items;
  final Function()? updateEvent;
  final String userkey;
  final bool isAdmin;
  final String officerName;
  EventBox(
      {super.key,
      required this.updateEvent,
      required this.userkey,
      required this.items,
      required this.isAdmin,
      required this.officerName});

  @override
  _EventBoxState createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
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
    DateTime now = DateTime.now();

    if (now.isAtSameMomentAs(event_end) || now.isAfter(event_end)) {
      if (isEventNotificationShown) {
        LocalNotifications.showNotification(
            'Event Status', 'Event ended attendance is not available');

        //ensure once
        isEventNotificationShown = false;
      }

      eventProvider.updateEventEndedData(item.id);

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

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final event = provider.eventList
            .firstWhere((element) => element.id == widget.items.id);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 14, 14.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.eventName,
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
                                            EventId: event.id,
                                            userKey: widget.userkey,
                                            officerName: widget.officerName,
                                            EventName: event.eventName,
                                          ))),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 26,
                              ),
                            )
                          : GestureDetector(
                              onTap: widget.updateEvent,
                              child: const Icon(
                                Icons.edit_note,
                                color: Colors.white,
                                size: 26,
                              ),
                            )
                      : const SizedBox.shrink(),
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
                      event.eventDescription,
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
                        event.eventPlace,
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
      },
    );
  }
}
