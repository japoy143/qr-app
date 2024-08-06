import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';
import 'package:qr_app/theme/colortheme.dart';

class CoursesSummaryScreen extends StatefulWidget {
  const CoursesSummaryScreen({super.key});

  @override
  State<CoursesSummaryScreen> createState() => _CoursesSummaryScreenState();
}

class _CoursesSummaryScreenState extends State<CoursesSummaryScreen> {
  int totalEvent = 29;

  final colorscheme = ColorThemeProvider();

  late Box<EventAttendance> _eventAttendanceBox;
  final eventAttendanceDB = EventAttendanceDatabase();

  @override
  void initState() {
    _eventAttendanceBox =
        eventAttendanceDB.eventAttendanceDatabaseInitialization();
    super.initState();
  }

  // courses in a list
  List<CoursesPenaltyType> penalty = [
    CoursesPenaltyType(courseName: 'BSIT', eventMissedCount: 0),
    CoursesPenaltyType(courseName: 'BSCS', eventMissedCount: 0),
    CoursesPenaltyType(courseName: 'BSIS', eventMissedCount: 0),
    CoursesPenaltyType(courseName: 'BSCPE', eventMissedCount: 0),
    CoursesPenaltyType(courseName: 'BSECE', eventMissedCount: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final eventAttendanceList = _eventAttendanceBox.values.toList();
    Color purple = Color(colorscheme.hexColor(colorscheme.primaryColor));

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
              'Total Events: $totalEvent',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade400,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: penalty.length,
                    itemBuilder: (context, index) {
                      final item = penalty.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(
                              color: purple,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(34),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.courseName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: colorscheme.secondaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Total event attended: ${item.eventMissedCount}',
                                    style: TextStyle(
                                        color: colorscheme.secondaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: Text(
                                  'See more',
                                  style: TextStyle(
                                      color: colorscheme.secondaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        )),
      ),
    );
  }
}
