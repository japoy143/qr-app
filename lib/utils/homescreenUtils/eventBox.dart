import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/theme/colortheme.dart';

class EventBoxHomescreen extends StatefulWidget {
  final EventType item;
  final bool isAdmin;

  EventBoxHomescreen({super.key, required this.isAdmin, required this.item});

  @override
  _EventBoxHomescreenState createState() => _EventBoxHomescreenState();
}

class _EventBoxHomescreenState extends State<EventBoxHomescreen> {
  late Timer _timer;
  late String _eventStatus;

  //items
  late EventType item;

  //colors
  final colorTheme = ColorThemeProvider();

  @override
  void initState() {
    item = widget.item;
    super.initState();
    _eventStatus = showEventStatus(item.startTime, item.endTime);
    _startTimer();
  }

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
    DateTime now = DateTime.now();

    if (now.isAtSameMomentAs(event_end) || now.isAfter(event_end)) {
      return 'Event Ended';
    }

    if (now.isAtSameMomentAs(date) || now.isAfter(date)) {
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
              _eventStatus == "Ongoing"
                  ? GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 26,
                      ),
                    )
                  : SizedBox.shrink(),
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
