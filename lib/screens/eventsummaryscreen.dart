import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/coursesSummary.dart';
import 'package:qr_app/utils/eventsummaryUtils/eventsummarybox.dart';

class EventSummaryScreen extends StatefulWidget {
  const EventSummaryScreen({super.key});

  @override
  State<EventSummaryScreen> createState() => _EventSummaryScreenState();
}

class _EventSummaryScreenState extends State<EventSummaryScreen> {
  int totalEvent = 0;

  //color theme
  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getEvents();
    super.initState();
  }

  final appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        //events
        List<EventType> allEvents = provider.eventList;

        //sort by date
        allEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));

        //filter event ended
        final sortedEventEnded =
            allEvents.where((event) => event.eventEnded == true).toList();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Events Summary',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Events Ended',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade400,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: sortedEventEnded.length,
                        itemBuilder: (context, index) {
                          final item = sortedEventEnded.elementAt(index);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CoursesSummaryScreen(
                                            eventName: item.eventName,
                                            screenHeight: screenHeight,
                                            eventId: item.id,
                                          ))),
                              child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: purple,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: EventSummayBox(
                                    items: item,
                                    screeHeight: (screenHeight +
                                        statusbarHeight +
                                        appBarHeight),
                                  )),
                            ),
                          );
                        })),
              ],
            )),
          ),
        );
      },
    );
  }
}
