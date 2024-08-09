import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/services/eventdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
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

  //database
  late Box<EventType> _eventBox;
  final eventDb = EventDatabase();

  @override
  void initState() {
    _eventBox = eventDb.EventDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

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
                child: ValueListenableBuilder<Box<EventType>>(
                    valueListenable: _eventBox.listenable(),
                    builder: (context, Box<EventType> box, _) {
                      //list of events
                      List<EventType> events = box.values.toList();

                      //sort event by date
                      events.sort((a, b) => a.eventDate.compareTo(b.eventDate));

                      //list of event ended
                      final eventEnded =
                          events.where((event) => event.eventEnded == true);

                      return ListView.builder(
                          itemCount: eventEnded.length,
                          itemBuilder: (context, index) {
                            final item = eventEnded.elementAt(index);

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: purple,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: EventSummayBox(items: item)),
                            );
                          });
                    })),
          ],
        )),
      ),
    );
  }
}
