import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';

class PenaltyScreen extends StatefulWidget {
  const PenaltyScreen({super.key});

  @override
  State<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  int eventMissed = 29;

  late Box<EventAttendance> _eventAttendanceBox;
  final eventAttendanceDB = EventAttendanceDatabase();

  @override
  void initState() {
    _eventAttendanceBox =
        eventAttendanceDB.eventAttendanceDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventAttendanceList = _eventAttendanceBox.values.toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Penalties',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Total Events Missed: ${eventMissed}',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade400,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: eventAttendanceList.length,
                    itemBuilder: (context, index) {
                      final item = eventAttendanceList.elementAt(index);

                      return Container(
                        decoration: const BoxDecoration(color: Colors.amberAccent),
                        padding: const EdgeInsets.all(6),
                        child: Text(item.officerName),
                      );
                    }))
          ],
        )),
      ),
    );
  }
}
