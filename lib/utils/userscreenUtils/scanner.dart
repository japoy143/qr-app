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
import 'package:qr_app/theme/colortheme.dart';
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
  String userSchoolId = '';
  String userName = '';
  String userCourse = '';
  String userYear = '';

  //is user data ready
  bool isUserDataFetch = false;

  //toast
  final toast = CustomToast();

  //color theme
  final colortheme = ColorThemeProvider();

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
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    //student details
    final details = data.split("|");
    setState(() {
      userSchoolId = details[0];
      userName = details[1];
      userCourse = details[2];
      userYear = details[3];
    });

    //check if validated
    if (userSchoolId == "0" &&
        userName == "0" &&
        userCourse == "0" &&
        userYear == "0") {
      toast.ValidateAccountFirst(context);
      return;
    }

    // set user image
    getUserUrlImage(userSchoolId);

    //check if student already attended
    final isAttended = await eventAttendanceProvider.containsStudent(
        widget.EventId, int.parse(userSchoolId));

    //TODO:here
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
      eventIdProvider.insertData(widget.EventId,
          EventsId(eventID: widget.EventId, isDataSaveOffline: false));
    }

    try {
      setState(() {
        isUserDataFetch = true;
      });
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
  Widget showProfile(String response, double screenWidth) {
    // online and http link is not  empty
    if (response != 'off' && response != '') {
      return CircleAvatar(
        radius: screenWidth >= 400 ? 130 : 100,
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

  final appBar = AppBar();
  @override
  Widget build(BuildContext context) {
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));
    String eventName = widget.EventName;
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        //initialize scanned user image
        final scannedImageUrl = provider.userScannedImage;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Scan Attendance'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/imgs/qr_code.png',
                                  scale: 24,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'CITECODE',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(color: purple),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                    ))
                  ],
                ),
                const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 180,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: scannedImageUrl != null
                              ? showProfile(scannedImageUrl, screenWIdth)
                              : const SizedBox.shrink(),
                        )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Text(
                            'Name: $userName',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Text(
                            'Course & Year: $userCourse-$userYear',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Text(
                            'School Id: $userSchoolId',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: isUserDataFetch
                                    ? () {
                                        setState(() {
                                          isUserDataFetch = false;
                                        });
                                      }
                                    : () {
                                        print('tapped');
                                      },
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      color: isUserDataFetch
                                          ? Colors.red
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                              GestureDetector(
                                onTap: isUserDataFetch
                                    ? () async {
                                        final eventAttendanceProvider = Provider
                                            .of<EventAttendanceProvider>(
                                                context,
                                                listen: false);

                                        final userProvider =
                                            Provider.of<UsersProvider>(context,
                                                listen: false);

                                        eventAttendanceProvider.insertData(
                                            userSchoolId,
                                            EventAttendance(
                                                id: int.parse(userSchoolId),
                                                eventId: widget.EventId,
                                                officerName: widget.officerName,
                                                studentId:
                                                    int.parse(userSchoolId),
                                                studentName: userName,
                                                studentCourse: userCourse,
                                                studentYear: userYear,
                                                isDataSaveOffline: false));

                                        final isUserAttended =
                                            await userProvider
                                                .updateUserNewAttendedEvent(
                                                    widget.EventId.toString(),
                                                    int.parse(userSchoolId));

                                        if (!isUserAttended) {
                                          toast.errorStudentNotSave(context);
                                          return;
                                        }
                                        //TODO: update user attendance
                                        toast.AttendanceSuccessfullySave(
                                            context);

                                        setState(() {
                                          isUserDataFetch = false;
                                        });
                                      }
                                    : () {
                                        print('tapped');
                                      },
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                      color: isUserDataFetch
                                          ? Colors.green
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                  ],
                ),
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
