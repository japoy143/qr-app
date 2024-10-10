import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/coursesSummary.dart';

class EventSummayBox extends StatefulWidget {
  final double screeHeight;
  final EventType items;
  final bool isAdmin;
  final String userAttendedEvent;
  final List<EventType> sortedEvent;

  EventSummayBox(
      {super.key,
      required this.items,
      required this.screeHeight,
      required this.isAdmin,
      required this.sortedEvent,
      required this.userAttendedEvent});

  @override
  _EventSummayBoxState createState() => _EventSummayBoxState();
}

class _EventSummayBoxState extends State<EventSummayBox> {
  late EventType item;

  //color
  final colorTheme = ColorThemeProvider();

  //date formatter to make 2024:00 00:00 to 8 pm
  String dateFormatter(DateTime date) {
    String formatted = DateFormat("h:mm a").format(date);

    return formatted;
  }

  @override
  void initState() {
    item = widget.items;
    super.initState();
  }

  String isUserAttended(int id) {
    if (widget.userAttendedEvent == "") {
      return "Missed";
    }

    List<String> eventIds =
        widget.userAttendedEvent.split("|").where((s) => s.isNotEmpty).toList();

    bool isAttended = eventIds.any((element) {
      try {
        int parsedId = int.parse(element);
        return parsedId == id;
      } catch (e) {
        print('Error parsing $element: $e');
        return false;
      }
    });

    return isAttended ? "Attended" : "Missed";
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
              GestureDetector(
                child: Text(
                  '${splittedDate[0]} ${splittedDate[1]}',
                  style: TextStyle(
                    color: colorTheme.secondaryColor,
                    fontFamily: "Poppins",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
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
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 6.0, 14.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                isUserAttended(item.id),
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontFamily: "Poppins",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 14.0, 0, 0),
                    child: Text(
                      "${dateFormatter(item.startTime)}  end: ${DateFormat("h:mm a").format(item.endTime)}",
                      style: TextStyle(
                        color: colorTheme.secondaryColor,
                        fontFamily: "Poppins",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              widget.isAdmin
                  ? GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CoursesSummaryScreen(
                                eventName: item.eventName,
                                screenHeight: widget.screeHeight,
                                eventId: item.id,
                                isAdmin: widget.isAdmin,
                                sortedEvent: widget.sortedEvent,
                              ))),
                      child: Text('See more',
                          style: TextStyle(
                            color: colorTheme.secondaryColor,
                            fontFamily: "Poppins",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          )),
                    )
                  : SizedBox.shrink(), //TODO: put here if user attended
            ],
          ),
        ),
      ],
    );
  }
}
