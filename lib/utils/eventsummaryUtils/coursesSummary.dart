import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/multipagepdf.dart';
import 'package:qr_app/utils/eventsummaryUtils/studentslistsummary.dart';

class CoursesSummaryScreen extends StatefulWidget {
  final String eventName;
  final double screenHeight;
  final int eventId;
  const CoursesSummaryScreen(
      {super.key,
      required this.eventId,
      required this.screenHeight,
      required this.eventName});

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

  //filter course attended
  int filterQuery(String courseName, String courseYear) {
    final eventAttendanceProvider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    eventAttendanceProvider.getEventAttendance();

    List<EventAttendance> eventAttendance =
        eventAttendanceProvider.eventAttendanceList;

    List<EventAttendance> eventIdFilter = eventAttendance
        .where((event) => event.eventId == widget.eventId)
        .toList();

    List courseFilter = eventIdFilter
        .where((event) =>
            event.studentCourse == courseName &&
            event.studentYear == courseYear)
        .toList();

    return courseFilter.length;
  }

  //filter course total
  int totalCourseAttended(String courseName) {
    final eventAttendanceProvider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    eventAttendanceProvider.getEventAttendance();

    List<EventAttendance> eventAttendance =
        eventAttendanceProvider.eventAttendanceList;

    List<EventAttendance> eventIdFilter = eventAttendance
        .where((event) =>
            event.eventId == widget.eventId &&
            event.studentCourse == courseName)
        .toList();

    return eventIdFilter.length;
  }

//totalStudent Attended
  int totalStudentAttended() {
    final eventAttendanceProvider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    eventAttendanceProvider.getEventAttendance();

    List<EventAttendance> eventAttendance =
        eventAttendanceProvider.eventAttendanceList;

    List<EventAttendance> eventIdFilter = eventAttendance
        .where((event) => event.eventId == widget.eventId)
        .toList();

    return eventIdFilter.length;
  }

  @override
  Widget build(BuildContext context) {
    Color purple = Color(colorscheme.hexColor(colorscheme.primaryColor));
    String formattedDate = DateFormat('MMM d').format(DateTime.now());
    String time = DateFormat('h:mm a').format(DateTime.now());
    String eventTime = '$formattedDate, $time';
    String eventName = widget.eventName;

    List<CoursesSummaryType> cellData = [
      CoursesSummaryType(
          courseName: 'BSIT',
          firstYear: filterQuery('BSIT', '1'),
          secondYear: filterQuery('BSIT', '2'),
          thirdYear: filterQuery('BSIT', '3'),
          fourthYear: filterQuery('BSIT', '4'),
          totalAttended: totalCourseAttended('BSIT')),
      CoursesSummaryType(
          courseName: 'BSCS',
          firstYear: filterQuery('BSCS', '1'),
          secondYear: filterQuery('BSCS', '2'),
          thirdYear: filterQuery('BSCS', '3'),
          fourthYear: filterQuery('BSCS', '4'),
          totalAttended: totalCourseAttended('BSCS')),
      CoursesSummaryType(
          courseName: 'BSIS',
          firstYear: filterQuery('BSIS', '1'),
          secondYear: filterQuery('BSIS', '2'),
          thirdYear: filterQuery('BSIS', '3'),
          fourthYear: filterQuery('BSIS', '4'),
          totalAttended: totalCourseAttended('BSIS')),
      CoursesSummaryType(
          courseName: 'BSCPE',
          firstYear: filterQuery('BSCPE', '1'),
          secondYear: filterQuery('BSCPE', '2'),
          thirdYear: filterQuery('BSCPE', '3'),
          fourthYear: filterQuery('BSCPE', '4'),
          totalAttended: totalCourseAttended('BSCPE')),
      CoursesSummaryType(
          courseName: 'BSECE',
          firstYear: filterQuery('BSECE', '1'),
          secondYear: filterQuery('BSECE', '2'),
          thirdYear: filterQuery('BSECE', '3'),
          fourthYear: filterQuery('BSECE', '4'),
          totalAttended: totalCourseAttended('BSECE')),
    ];

    final data = cellData
        .map((e) => [
              e.courseName,
              e.firstYear,
              e.secondYear,
              e.thirdYear,
              e.fourthYear,
              e.totalAttended
            ])
        .toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<UsersProvider>(
            builder: (context, provider, widget) {
              provider.getUsers();
              List<UsersType> allUsers = provider.userList;

              //filter admins
              List<UsersType> onlyStudent = allUsers
                  .where((element) => element.isAdmin == false)
                  .toList();

              // Sort user alphabetically (case-insensitive)
              List<UsersType> alphabeticalStudents = onlyStudent.toList()
                ..sort((a, b) => a.userName
                    .toLowerCase()
                    .compareTo(b.userName.toLowerCase()));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                    onTap: () async {},
                    child: const Icon(
                      Icons.picture_as_pdf,
                      size: 30,
                    )),
              );
            },
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
                      'Total Student Attended: ${totalStudentAttended()}',
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
