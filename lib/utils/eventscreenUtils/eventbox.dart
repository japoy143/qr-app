import 'package:flutter/material.dart';
import 'package:qr_app/models/events.dart';
import 'package:intl/intl.dart';

class EventBox extends StatelessWidget {
  final String eventName;
  final String eventDescription;
  final Color colorWhite;
  final String eventStatus;
  final DateTime eventDate;
  final bool isAdmin;
  EventBox(
      {super.key,
      required this.eventName,
      required this.colorWhite,
      required this.eventDescription,
      required this.eventStatus,
      required this.eventDate,
      required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM d').format(eventDate);
    List splittedDate = formattedDate.split(" ");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 14, 14.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eventName,
                style: TextStyle(
                    color: colorWhite,
                    fontFamily: "Poppins",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
              isAdmin
                  ? GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.qr_code_scanner,
                        color: colorWhite,
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
                  eventDescription,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontFamily: "Poppins",
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 20.0,
              )
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
                    'Gym',
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14.0, 0, 0),
                    child: Text(
                      eventStatus,
                      style: TextStyle(
                          color: colorWhite,
                          fontFamily: "Poppins",
                          fontSize: 19.0,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    splittedDate[0],
                    style: TextStyle(
                        color: colorWhite,
                        fontFamily: "Poppins",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(splittedDate[1],
                      style: TextStyle(
                          color: colorWhite,
                          fontFamily: "Poppins",
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
