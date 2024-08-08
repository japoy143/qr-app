import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/studentslistsummary.dart';

class CoursesSummaryScreen extends StatefulWidget {
  final int eventId;
  const CoursesSummaryScreen({super.key, required this.eventId});

  @override
  State<CoursesSummaryScreen> createState() => _CoursesSummaryScreenState();
}

class _CoursesSummaryScreenState extends State<CoursesSummaryScreen> {
  int totalEvent = 29;

  final colorscheme = ColorThemeProvider();

  late Box<EventAttendance> _eventAttendanceBox;

  @override
  void initState() {
    super.initState();
  }

  // courses in a list
  List<CoursesEventType> penalty = [
    CoursesEventType(courseName: 'BSIT', eventAttended: 0),
    CoursesEventType(courseName: 'BSCS', eventAttended: 0),
    CoursesEventType(courseName: 'BSIS', eventAttended: 0),
    CoursesEventType(courseName: 'BSCPE', eventAttended: 0),
    CoursesEventType(courseName: 'BSECE', eventAttended: 0),
  ];
  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  @override
  Widget build(BuildContext context) {
    Color purple = Color(colorscheme.hexColor(colorscheme.primaryColor));

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 8, 14, 0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade900)),
                    child: DropDown(
                      initialValue: selectedYear,
                      showUnderline: false,
                      items: year,
                      onChanged: (val) {
                        setState(() {
                          selectedYear = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                                    'Total event attended: ${item.eventAttended}',
                                    style: TextStyle(
                                        color: colorscheme.secondaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentListSummary(
                                              courseName: item.courseName,
                                              yearLevel: selectedYear,
                                              eventId: widget.eventId,
                                            ))),
                                child: Text(
                                  'Student attended',
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
