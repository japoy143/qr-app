import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/eventattendance.dart';
import 'package:qr_app/models/eventsid.dart';
import 'package:qr_app/state/eventAttendanceProvider.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
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
  String userSchoolId = 'Student Id';
  String userName = 'Student Name';
  String userCourse = 'Course';
  String userYear = 'Year';

  //toast
  final toast = CustomToast();

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
  formatUserDetails(String data) async {
    final eventAttendanceProvider =
        Provider.of<EventAttendanceProvider>(context, listen: false);
    final eventIdProvider =
        Provider.of<EventIdProvider>(context, listen: false);
    //student details
    final details = data.split("|");
    setState(() {
      userSchoolId = details[0];
      userName = details[1];
      userCourse = details[2];
      userYear = details[3];
    });

    // set user image
    getUserUrlImage(userSchoolId);

    //check if student already attended
    final isAttended = await eventAttendanceProvider.containsStudent(
        widget.EventId, int.parse(userSchoolId));

    //check if ids is already exist
    final isIdAlreadyExist =
        await eventIdProvider.containsEventId(widget.EventId);

    //check if student already scanned
    if (isAttended) {
      toast.AlreadyAttended(context);
      return;
    }

    //check if id is not in the stack then put it in the stack
    //if already in the stack then continue. make sure only on id in the stack
    //then remove the id if all the data is sent to the online database
    if (!isIdAlreadyExist) {
      eventIdProvider.insertData(
          widget.EventId, EventsId(eventID: widget.EventId));
    }

    try {
      eventAttendanceProvider.insertData(
          userSchoolId,
          EventAttendance(
              id: int.parse(userSchoolId),
              eventId: widget.EventId,
              officerName: widget.officerName,
              studentId: int.parse(userSchoolId),
              studentName: userName,
              studentCourse: userCourse,
              studentYear: userYear));

      //TODO: update user attendance
      toast.AttendanceSuccessfullySave(context);
    } catch (e) {
      toast.errorStudentNotSave(context);
    }
  }

  // get user profile in server
  getUserUrlImage(String id) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    //get scanned user using id
    userProvider.getScannedUserImage(id);
  }

  // return profile condition
  Widget showProfile(String response) {
    // online and http link is not  empty
    if (response != 'off' && response != '') {
      return CircleAvatar(
        radius: 140,
        backgroundImage:
            NetworkImage(response), // Use NetworkImage for URL-based images
        backgroundColor: Colors.transparent,
      );
    }

    //default
    return const Icon(
      Icons.account_circle_rounded,
      size: 200.0,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        //initialize scanned user image
        final scannedImageUrl = provider.userScannedImage;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Scan Attendance'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                  child: scannedImageUrl != null
                      ? showProfile(scannedImageUrl)
                      : const SizedBox.shrink(),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$userCourse-$userYear',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  userSchoolId,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: startscan,
            child: const Icon(Icons.qr_code_scanner),
          ),
        );
      },
    );
  }
}
