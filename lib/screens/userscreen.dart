import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_app/models/positions.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/theme/colortheme.dart';

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
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: (screenHeight - statusbarHeight) * 0.10,
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
                          size: (screenHeight - statusbarHeight) * 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                              '${isAdmin ? adminPosition.positions[userSchoolId] : "Student"}'),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                      backgroundColor: colortheme.secondaryColor,
                      child: Image.asset(notification != 0
                          ? 'assets/imgs/isnotified.png'
                          : 'assets/imgs/notified.png'))
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
            Text('Scan this code to verify your attendance'),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Container(
                height: (screenHeight - statusbarHeight) * 0.34,
                decoration: BoxDecoration(color: colortheme.secondaryColor),
                child: PrettyQrView.data(
                    data: qrData,
                    decoration: const PrettyQrDecoration(
                        image: PrettyQrDecorationImage(
                            image: AssetImage('assets/imgs/logo.png')))),
              ),
            )
          ],
        )),
      ),
    );
  }
}
