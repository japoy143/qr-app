import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_app/models/positions.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/theme/notification_active.dart';
import 'package:qr_app/theme/notification_none.dart';

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

  late Box<UsersType> _userBox;
  final userDb = UsersDatabase();

  @override
  void initState() {
    // TODO: implement initState
    _userBox = userDb.UsersDatabaseInitialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //screen queries
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    //userDetails
    final userDetails = _userBox.get(widget.userKey);
    final userName = userDetails!.userName;
    final userSchoolId = userDetails.schoolId;
    final userCourse = userDetails.userCourse;
    final userYear = userDetails.userYear;
    final isAdmin = userDetails.isAdmin;

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 20, 14, 0),
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
                      CircleAvatar(
                        backgroundColor: colortheme.secondaryColor,
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: (screenHeight - statusbarHeight) * 0.07,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
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
                    data: qrData,
                    decoration: const PrettyQrDecoration(
                        image: PrettyQrDecorationImage(
                            image: AssetImage('assets/imgs/lsg_logo.png')))),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '10',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Total Events')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '8',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Events attended')
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Events missed')
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
