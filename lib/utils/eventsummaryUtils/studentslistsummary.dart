import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventlistattendance.dart';
import 'package:qr_app/services/eventListAttendance.dart';

class StudentListSummary extends StatefulWidget {
  final String courseName;
  final int? yearLevel;
  final int eventId;

  StudentListSummary(
      {super.key,
      required this.courseName,
      required this.yearLevel,
      required this.eventId});

  @override
  State<StudentListSummary> createState() => _StudentListSummaryState();
}

class _StudentListSummaryState extends State<StudentListSummary> {
  //event list attendance
  late Box<EventAttendanceList> _eventAttendanceBox;
  final eventAttendanceDB = EventListAttendanceDatabase();

  @override
  void initState() {
    _eventAttendanceBox =
        eventAttendanceDB.EventAttendanceListDatabaseIntialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventAttendList = _eventAttendanceBox.get(widget.eventId);

    final event =
        eventAttendList?.attendanceList;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 8, 14, 0),
        child: SafeArea(
            child: Column(
          children: [
            Text(
              '${widget.courseName}-${widget.yearLevel}',
              style: TextStyle(
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
            Expanded(
                child: event == null
                    ? Text('No Data')
                    : ListView.builder(
                        itemCount: event.length,
                        itemBuilder: (context, index) {
                          final item = event.elementAt(index);

                          return Container(
                            child: Text(item.officerName),
                          );
                        })),
          ],
        )),
      ),
    );
  }
}
