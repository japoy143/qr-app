import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/theme/colortheme.dart';

class EventEndedBoxHomescreen extends StatefulWidget {
  final EventType items;
  final bool isAdmin;
  final String userKey;
  final String officerName;

  EventEndedBoxHomescreen(
      {super.key,
      required this.isAdmin,
      required this.items,
      required this.userKey,
      required this.officerName});

  @override
  _EventEndedBoxHomescreenState createState() =>
      _EventEndedBoxHomescreenState();
}

class _EventEndedBoxHomescreenState extends State<EventEndedBoxHomescreen> {
  late EventType item;

  bool isOngoingNotificationShown = true;
  bool isEventNotificationShown = true;

  //color
  final colorTheme = ColorThemeProvider();

  @override
  void initState() {
    item = widget.items;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM d').format(item.eventDate);
    List splittedDate = formattedDate.split(" ");

    return Stack(
      children: [
        SvgPicture.asset(
          'assets/imgs/pattern4.svg',
          fit: BoxFit.fill,
        ),
        Column(
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
                          'Event Ended',
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
        )
      ],
    );
  }
}
