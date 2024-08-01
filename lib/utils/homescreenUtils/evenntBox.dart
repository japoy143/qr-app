import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventBoxHomescreen extends StatefulWidget {
  final String eventName;
  final String eventDescription;
  final String eventPlace;
  final Color colorWhite;
  final String eventStatus;
  final DateTime eventDate;
  final DateTime eventEnded;
  final bool isAdmin;
  final DateTime eventStartTime;

  EventBoxHomescreen({
    super.key,
    required this.eventName,
    required this.colorWhite,
    required this.eventDescription,
    required this.eventStatus,
    required this.eventDate,
    required this.isAdmin,
    required this.eventPlace,
    required this.eventStartTime,
    required this.eventEnded,
  });

  @override
  _EventBoxHomescreenState createState() => _EventBoxHomescreenState();
}

class _EventBoxHomescreenState extends State<EventBoxHomescreen> {
  late Timer _timer;
  late String _eventStatus;

  @override
  void initState() {
    super.initState();
    _eventStatus = showEventStatus(widget.eventStartTime, widget.eventEnded);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _eventStatus =
            showEventStatus(widget.eventStartTime, widget.eventEnded);
        if (DateTime.now().isAfter(widget.eventEnded)) {
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
    String formattedDate = DateFormat('MMM d').format(widget.eventDate);
    List splittedDate = formattedDate.split(" ");

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 14, 14.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.eventName,
                style: TextStyle(
                  color: widget.colorWhite,
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
                  widget.eventDescription,
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
                    widget.eventPlace,
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
                        color: widget.colorWhite,
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
                      color: widget.colorWhite,
                      fontFamily: "Poppins",
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    splittedDate[1],
                    style: TextStyle(
                      color: widget.colorWhite,
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
