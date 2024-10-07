import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/events.dart';
import 'package:qr_app/models/penaltyvalues.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/penaltyValues.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/eventsummaryUtils/multipagepdf.dart';
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

    _studentNameController.addListener(_updateNotFoundMessage);
  }

  @override
  void dispose() {
    _studentNameController.removeListener(_updateNotFoundMessage);
    _studentNameController.dispose();
    super.dispose();
  }

  void _updateNotFoundMessage() {
    final filteredList = _filteredList();
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
            .where((search) => search.studentName
                .toLowerCase()
                .contains(_studentNameController.text.toLowerCase()))
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
                    children: [
                      Text(
                        '${widget.courseName}-${widget.yearLevel}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      // Consumer<UsersProvider>(
                      //   builder: (context, provider, widget) {
                      //     List<UsersType> allUsers = provider.userList;

                      //     //filter admins
                      //     List<UsersType> onlyStudent = allUsers
                      //         .where((element) =>
                      //             element.isAdmin == false &&
                      //             element.isUserValidated == true &&
                      //             element.isValidationRep == false &&
                      //             element.userCourse == courseName &&
                      //             element.userYear == year.toString())
                      //         .toList();

                      //     // Sort user alphabetically (case-insensitive)
                      //     List<UsersType> alphabeticalStudents = onlyStudent
                      //         .toList()
                      //       ..sort((a, b) => a.userName
                      //           .toLowerCase()
                      //           .compareTo(b.userName.toLowerCase()));

                      //     return Padding(
                      //       padding:
                      //           const EdgeInsets.symmetric(horizontal: 30.0),
                      //       child: Consumer<PenaltyValuesProvider>(
                      //         builder: (context, provider, child) {
                      //           List<PenaltyValues> penaltyValuesList =
                      //               provider.penaltyList;

                      //           return isAdmin
                      //               ? GestureDetector(
                      //                   onTap: () async {
                      //                     SaveAndDownloadMultiplePdf.createPdf(
                      //                         events: sortedEvent,
                      //                         users: alphabeticalStudents,
                      //                         penaltyValues: penaltyValuesList);
                      //                   },
                      //                   child: const Icon(
                      //                     Icons.picture_as_pdf,
                      //                     size: 30,
                      //                   ))
                      //               : SizedBox.shrink();
                      //         },
                      //       ),
                      //     );
                      //   },
                      // )
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
                              itemCount: _filteredList().length,
                              itemBuilder: (context, index) {
                                final item = _filteredList().elementAt(index);
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
