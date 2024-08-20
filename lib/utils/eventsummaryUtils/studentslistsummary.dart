import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class StudentListSummary extends StatefulWidget {
  final double screenHeight;
  final String courseName;
  final int? yearLevel;
  final int eventId;

  const StudentListSummary({
    super.key,
    required this.courseName,
    required this.yearLevel,
    required this.eventId,
    required this.screenHeight,
  });

  @override
  State<StudentListSummary> createState() => _StudentListSummaryState();
}

class _StudentListSummaryState extends State<StudentListSummary> {
  late Box<EventAttendance> _eventAttendanceBox;
  final eventAttendanceDB = EventAttendanceDatabase();
  final TextEditingController _studentNameController = TextEditingController();
  bool _showNotFoundMessage = false;

  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    _eventAttendanceBox =
        eventAttendanceDB.eventAttendanceDatabaseInitialization();
    _studentNameController.addListener(() {
      setState(() {}); // Trigger UI update on text change
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //attendance list
    final attendance = _eventAttendanceBox.values.toList();
    //event attendance list
    final eventIdAttendanceList =
        attendance.where((event) => event.eventId == widget.eventId);
    // sort by course and year
    final sortedCoursesAndYear = eventIdAttendanceList.where((courseYear) =>
        courseYear.studentCourse == widget.courseName &&
        courseYear.studentYear == widget.yearLevel.toString());

    final filteredList = _studentNameController.text.isEmpty
        ? sortedCoursesAndYear
        : sortedCoursesAndYear.where((search) => search.studentName
            .toLowerCase()
            .contains(_studentNameController.text.toLowerCase()));

    //color purple
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    //setter
    setState(() {
      _showNotFoundMessage = filteredList.isEmpty;
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 8, 14, 0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.courseName}-${widget.yearLevel}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'students',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade400,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Search Students',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              CustomTextField(
                height: widget.screenHeight,
                  hintext: 'enter student name',
                  controller: _studentNameController,
                  keyBoardType: TextInputType.text,
                  isReadOnly: false),
              const SizedBox(height: 10),
              Expanded(
                  child: _showNotFoundMessage
                      ? const Center(child: Text("Student not found"))
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList.elementAt(index);
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: purple,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.studentName,
                                        style: TextStyle(
                                            color: colortheme.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "${item.studentCourse}-${item.studentYear}",
                                        style: TextStyle(
                                            color: colortheme.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          })),
            ],
          ),
        ),
      ),
    );
  }
}
