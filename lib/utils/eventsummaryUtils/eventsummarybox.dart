import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/coursesSummary.dart';

class EventSummayBox extends StatefulWidget {
  final EventType items;

  EventSummayBox({
    super.key,
    required this.items,
  });

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
                      dateFormatter(item.startTime),
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
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CoursesSummaryScreen(
                          eventId: item.id,
                        ))),
                child: Text('See more',
                    style: TextStyle(
                      color: colorTheme.secondaryColor,
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }
}
