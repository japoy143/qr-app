import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';

class StudentListSummary extends StatefulWidget {
  final double screenHeight;
  final String courseName;
  final int? yearLevel;
  final int eventId;
  final bool isAdmin;
  final List<EventType> sortedEvent;

  const StudentListSummary(
      {super.key,
      required this.courseName,
      required this.yearLevel,
      required this.eventId,
      required this.screenHeight,
      required this.isAdmin,
      required this.sortedEvent});

  @override
  State<StudentListSummary> createState() => _StudentListSummaryState();
}

class _StudentListSummaryState extends State<StudentListSummary> {
  final TextEditingController _studentNameController = TextEditingController();
  bool _showNotFoundMessage = false;

  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    super.initState();
    Provider.of<EventAttendanceProvider>(context, listen: false)
        .getEventAttendance();
    Provider.of<UsersProvider>(context, listen: false).getUsers();

    _studentNameController.addListener(_updateNotFoundMessage);
  }

  @override
  void dispose() {
    _studentNameController.removeListener(_updateNotFoundMessage);
    _studentNameController.dispose();
    super.dispose();
  }

  String? selectedStatus = 'not-attended';
  List<String> selectionStatus = ['attended', 'not-attended'];

  void _updateNotFoundMessage() {
    final filteredList = selectedStatus == 'attended'
        ? _filteredList()
        : _notAttendedFilteredList();
    setState(() {
      _showNotFoundMessage =
          _studentNameController.text.isNotEmpty && filteredList.isEmpty;
    });
  }

  List _filteredList() {
    final provider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    final attendance = provider.eventAttendanceList;

    final eventIdAttendanceList =
        attendance.where((event) => event.eventId == widget.eventId).toList();

    final sortedCoursesAndYear = eventIdAttendanceList
        .where((courseYear) =>
            courseYear.studentCourse == widget.courseName &&
            courseYear.studentYear == widget.yearLevel.toString())
        .toList();

    return _studentNameController.text.isEmpty
        ? sortedCoursesAndYear
        : sortedCoursesAndYear
            .where((search) =>
                search.studentName
                    .toLowerCase()
                    .contains(_studentNameController.text.toLowerCase()) ||
                search.studentId
                    .toString()
                    .contains(_studentNameController.text))
            .toList();
  }

  List _notAttendedFilteredList() {
    final provider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    final attendance = provider.eventAttendanceList;

    final users = Provider.of<UsersProvider>(context, listen: false);
    final allStudents = users.userList;

    final studentsOnly = allStudents
        .where((element) =>
            element.isValidationRep != true &&
            element.isAdmin != true &&
            element.userCourse == widget.courseName &&
            element.userYear == widget.yearLevel.toString())
        .toList();

    final eventIdAttendanceList =
        attendance.where((event) => event.eventId == widget.eventId).toList();

    final sortedCoursesAndYear = eventIdAttendanceList
        .where((courseYear) =>
            courseYear.studentCourse == widget.courseName &&
            courseYear.studentYear == widget.yearLevel.toString())
        .toList();

    List<EventAttendance> filteredNotAttended = [];

    int counter = 0;
    studentsOnly.forEach((student) {
      bool isAttended = sortedCoursesAndYear
          .any((element) => element.studentId == student.schoolId);

      if (!isAttended) {
        filteredNotAttended.add(EventAttendance(
            id: counter,
            eventId: widget.eventId,
            officerName: '',
            studentId: student.schoolId,
            studentName: '${student.userName} ${student.lastName}',
            studentCourse: student.userCourse,
            studentYear: student.userYear,
            isDataSaveOffline: false));
      }
      counter++;
    });

    return _studentNameController.text.isEmpty
        ? filteredNotAttended
        : filteredNotAttended
            .where((search) =>
                search.studentName
                    .toLowerCase()
                    .contains(_studentNameController.text.toLowerCase()) ||
                search.studentId
                    .toString()
                    .contains(_studentNameController.text))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.isAdmin;
    List<EventType> sortedEvent = widget.sortedEvent;
    String courseName = widget.courseName;
    int? year = widget.yearLevel;
    return Consumer<EventAttendanceProvider>(
      builder: (context, provider, child) {
        Color purple = Color(colortheme.hexColor(colortheme.primaryColor));
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
                      Text(
                        '${widget.courseName}-${widget.yearLevel}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey.shade900)),
                          child: DropDown(
                            initialValue: selectedStatus,
                            showUnderline: false,
                            items: selectionStatus,
                            onChanged: (val) {
                              setState(() {
                                selectedStatus = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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
                              itemCount: selectedStatus == 'attended'
                                  ? _filteredList().length
                                  : _notAttendedFilteredList().length,
                              itemBuilder: (context, index) {
                                final item = selectedStatus == 'attended'
                                    ? _filteredList().elementAt(index)
                                    : _notAttendedFilteredList()
                                        .elementAt(index);
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Container(
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
                                                  color:
                                                      colortheme.secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              "${item.studentCourse}-${item.studentYear}",
                                              style: TextStyle(
                                                  color:
                                                      colortheme.secondaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
