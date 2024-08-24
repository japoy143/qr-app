import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/generatePdf.dart';
import 'package:qr_app/utils/eventsummaryUtils/pdfUi.dart';
import 'package:qr_app/utils/eventsummaryUtils/studentslistsummary.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CoursesSummaryScreen extends StatefulWidget {
  final double screenHeight;
  final int eventId;
  const CoursesSummaryScreen(
      {super.key, required this.eventId, required this.screenHeight});

  @override
  State<CoursesSummaryScreen> createState() => _CoursesSummaryScreenState();
}

class _CoursesSummaryScreenState extends State<CoursesSummaryScreen> {
  int totalEvent = 29;

  final colorscheme = ColorThemeProvider();

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
    final data = penalty.map((e) => [e.courseName, e.eventAttended]).toList();
    String formattedDate = DateFormat('MMM d').format(DateTime.now());
    String time = DateFormat('h:mm a').format(DateTime.now());
    String eventTime = '$formattedDate,$time';

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: GestureDetector(
                onTap: () async {
                  SaveAndDownloadPdf.createPdf(
                      eventTime: eventTime,
                      eventName: 'Seminar',
                      eventDescription: 'Drug awarness seminar',
                      totalAttended: 100,
                      data: data);
                },
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                )),
          )
        ],
      ),
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
                      'Courses Attended',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Students Attended: $totalEvent',
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
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StudentListSummary(
                                        screenHeight: widget.screenHeight,
                                        courseName: item.courseName,
                                        yearLevel: selectedYear,
                                        eventId: widget.eventId,
                                      ))),
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
                                                screenHeight:
                                                    widget.screenHeight,
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
                        ),
                      );
                    }))
          ],
        )),
      ),
    );
  }
}
