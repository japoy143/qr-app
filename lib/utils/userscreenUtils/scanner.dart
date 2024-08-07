import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/eventlistattendance.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';
import 'package:qr_app/services/eventListAttendance.dart';
import 'package:qr_app/services/usersdatabase.dart';

class QrCodeScanner extends StatefulWidget {
  int EventId;
  String EventName;
  String userKey;

  QrCodeScanner({
    super.key,
    required this.EventId,
    required this.EventName,
    required this.userKey,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String _scanBarcode = '';

  String userSchoolId = '100001';
  String userName = 'Student Name';
  String userCourse = 'BSIT';
  String userYear = '4';

  //database
  late Box<EventAttendanceList> _eventAttendanceListBox;
  final eventAttendanceListDb = EventListAttendanceDatabase();

  //officer
  late Box<UsersType> _usersBox;
  final usersDb = UsersDatabase();

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

    setState(() {
      _scanBarcode = result;
    });
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

    //TODO: put officer details by quering
    //officer details
    final officerDetails = _usersBox.get(int.parse(widget.userKey));
    final officerName = officerDetails!.userName;

    //save student details
    _eventAttendanceListBox.put(
        widget.EventId,
        EventAttendanceList(
            eventId: widget.EventId,
            eventName: widget.EventName,
            attendanceList: <EventListAttendanceType>[
              EventListAttendanceType(
                  eventId: widget.EventId,
                  officerId: int.parse(widget.userKey),
                  officerName: officerName,
                  studentId: int.parse(userSchoolId),
                  studentName: userName,
                  studentCourse: userCourse,
                  studentYear: userYear)
            ]));
  }

  @override
  void initState() {
    _eventAttendanceListBox =
        eventAttendanceListDb.EventAttendanceListDatabaseIntialization();
    _usersBox = usersDb.UsersDatabaseInitialization();
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
