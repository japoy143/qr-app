import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/eventsid.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';
import 'package:qr_app/services/eventIdsdatabase.dart';
import 'package:qr_app/utils/toast.dart';

// ignore: must_be_immutable
class QrCodeScanner extends StatefulWidget {
  int EventId;
  String EventName;
  String userKey;
  String officerName;

  QrCodeScanner({
    super.key,
    required this.EventId,
    required this.EventName,
    required this.userKey,
    required this.officerName,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String userSchoolId = '100001';
  String userName = 'Student Name';
  String userCourse = 'BSIT';
  String userYear = '4';

  //toast
  final toast = CustomToast();

  //database
  late Box<EventAttendance> _eventAttendance;
  final eventAttendanceDB = EventAttendanceDatabase();

  late Box<EventsId> _eventIdsBox;
  final eventIdsDB = EventIdDatabase();

  startscan() async {
    var result;

    try {
      result = await FlutterBarcodeScanner.scanBarcode(
          '#FFFFFF', 'Cancel', true, ScanMode.QR);
      formatUserDetails(result);
    } on PlatformException catch (e) {
      result = 'Failed to get platform version';
      Get.snackbar('Error', e.code);
    } catch (e) {
      return;
    }
    if (!mounted) return;

    setState(() {});
  }

  //user details formatter and save the scanned data
  formatUserDetails(String data) {
    //student details
    final details = data.split("|");
    setState(() {
      userSchoolId = details[0];
      userName = details[1];
      userCourse = details[2];
      userYear = details[3];
    });

    //check if student already attended
    final isAttended = _eventAttendance.containsKey(userSchoolId);

    //check if ids is already exist
    final isIdAlreadyExist = _eventIdsBox.containsKey(widget.EventId);

    //check if student already scanned
    if (isAttended) {
      toast.AlreadyAttended(context);
      return;
    }

    //check if id is not in the stack then put it in the stack
    //if already in the stack then continue. make sure only on id in the stack
    //then remove the id if all the data is sent to the online database
    if (isIdAlreadyExist) {
      _eventIdsBox.put(widget.EventId, EventsId(eventID: widget.EventId));
    }

    try {
      _eventAttendance.put(
          userSchoolId,
          EventAttendance(
              id: int.parse(userSchoolId),
              eventId: widget.EventId,
              officerName: widget.officerName,
              studentId: int.parse(userSchoolId),
              studentName: userName,
              studentCourse: userCourse,
              studentYear: userYear));
      toast.AttendanceSuccessfullySave(context);
    } catch (e) {
      toast.errorStudentNotSave(context);
    }
  }

  @override
  void initState() {
    _eventAttendance =
        eventAttendanceDB.eventAttendanceDatabaseInitialization();
    _eventIdsBox = eventIdsDB.EventIdDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Attendance'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
              child: Icon(
                Icons.account_circle_rounded,
                size: 200.0,
              ),
              // child: CircleAvatar(
              //   radius: 100,
              //   backgroundColor: Colors.red,
              // ),
            ),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '$userCourse-$userYear',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              userSchoolId,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startscan,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
