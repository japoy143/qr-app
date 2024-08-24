import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
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
