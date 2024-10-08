import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/theme/notification_active.dart';
import 'package:qr_app/theme/notification_none.dart';
import 'package:qr_app/utils/toast.dart';
import 'package:qr_app/utils/userscreenUtils/eventSummary.dart';

class UserScreen extends StatefulWidget {
  final String userKey;
  UserScreen({super.key, required this.userKey});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final colortheme = ColorThemeProvider();
  int notification = 1;
  final adminPosition = adminPositions();

  //toast
  final toast = CustomToast();

  void showToast() {
    toast.profileSuccessfullyChange(context);
  }

  //image type
  XFile? selectedimage;

  getImage(int id, String userName, String userCourse, String userYear,
      String userPassword, bool isAdmin, String userProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedimage = image;
    });

    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    userProvider.insertData(
        id.toString(),
        UsersType(
            schoolId: id,
            key: userName,
            userName: userName,
            userCourse: userCourse,
            userYear: userYear,
            userPassword: userPassword,
            isAdmin: isAdmin,
            userProfile: image == null ? userProfile : image.path));

    showToast();
  }

  final appBar = AppBar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    //screen queries
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    //userDetails
    final userDetails = userProvider.getUser(widget.userKey);
    final userName = userDetails!.userName;
    final userSchoolId = userDetails.schoolId;
    final userCourse = userDetails.userCourse;
    final userYear = userDetails.userYear;
    final isAdmin = userDetails.isAdmin;
    final userPassword = userDetails.userPassword;
    final userProfile = userDetails.userProfile;

    //for qr data
    String qrData = [
      userSchoolId.toString(),
      "|",
      userName,
      "|",
      userCourse,
      "|",
      userYear
    ].join("");

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 0, 14, 0),
          child: Column(
            children: [
              SizedBox(
                height: (screenHeight - statusbarHeight) * 0.12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          child: GestureDetector(
                            onTap: () => getImage(
                                userSchoolId,
                                userName,
                                userCourse,
                                userYear,
                                userPassword,
                                isAdmin,
                                userProfile),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  userProfile == ""
                                      ? Icon(
                                          Icons.account_circle_outlined,
                                          size:
                                              (screenHeight - statusbarHeight) *
                                                  0.07,
                                        )
                                      : CircleAvatar(
                                          radius:
                                              (screenHeight - statusbarHeight) *
                                                  0.035,
                                          backgroundImage:
                                              FileImage(File(userProfile)),
                                          backgroundColor: Colors.transparent,
                                        ),
                                  const Positioned(
                                    left: 36,
                                    bottom: 14,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.blueGrey,
                                      size: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                userName,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                                '${isAdmin ? adminPosition.positions[userSchoolId] : "Student"}'),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Container(
                        child: notification != 0
                            ? const NotificationActive(height: 26, width: 26)
                            : const NotificationNone(
                                height: 26,
                                width: 26,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 8),
                child: Text(
                  'Scan QR Code',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Text('Scan this code to verify your attendance'),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Container(
                  height: (screenHeight - statusbarHeight) * 0.34,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: colortheme.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 4,
                        color: Colors.grey.shade300,
                      )),
                  child: PrettyQrView.data(
                      data: qrData, decoration: const PrettyQrDecoration()),
                ),
              ),
              Text(
                userName,
                style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
              ),
              Text(
                '$userCourse-$userYear',
                style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('Event Summary'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EventSummary(counter: '10', eventName: 'TotalEvents'),
                    EventSummary(counter: '8', eventName: 'Events Attended'),
                    EventSummary(counter: '2', eventName: 'Events Missed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
