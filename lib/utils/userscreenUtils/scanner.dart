import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/services/eventAttendanceDatabase.dart';

class QrCodeScanner extends StatefulWidget {
  int EventId;
  String userKey;
  QrCodeScanner({super.key, required this.EventId, required this.userKey});

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
  late Box<EventAttendance> _eventAttendanceBox;
  final eventAttendanceDb = EventAttendanceDatabase();

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
    final details = data.split("|");
    setState(() {
      userSchoolId = details[0];
      userName = details[1];
      userCourse = details[2];
      userYear = details[3];
    });
    _eventAttendanceBox.put(
        details[0],
        EventAttendance(
            id: int.parse(details[0]),
            eventId: widget.EventId,
            officerName: widget.userKey,
            studentId: int.parse(details[0]),
            studentName: details[1],
            studentCourse: details[2],
            studentYear: details[3]));
  }

  @override
  void initState() {
    _eventAttendanceBox =
        eventAttendanceDb.eventAttendanceDatabaseInitialization();
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
