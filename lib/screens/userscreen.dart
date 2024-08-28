import 'dart:io';
import 'package:flutter/material.dart';
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
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  getImage(
      int id,
      String userName,
      String userCourse,
      String userYear,
      String userPassword,
      bool isAdmin,
      String userProfile,
      bool isSignUpOnline) async {
    //image picker
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    setState(() {
      selectedimage = image;
    });

    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    try {
      final ImageExtension = image.path.split('.').last.toLowerCase();
      final imageBytes = await image.readAsBytes();
      final imagePath = '$id/image';
      await Supabase.instance.client.storage.from('profiles').uploadBinary(
          imagePath, imageBytes,
          fileOptions:
              FileOptions(upsert: true, contentType: 'image/$ImageExtension'));

      //update state
      userProvider.getUserImage(id.toString());

      print('uploaded');
    } catch (e) {
      print(e);
    }

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
          userProfile: image.path,
          isSignupOnline: isSignUpOnline,
        ));

    showToast();
  }

  //return profile
  Widget showProfile(String imagePath, String response, double screenHeight,
      double statusbarHeight) {
    // online and http link is not  empty
    if (response != 'off' && response != '') {
      return CircleAvatar(
        radius: (screenHeight - statusbarHeight) * 0.035,
        backgroundImage:
            NetworkImage(response), // Use NetworkImage for URL-based images
        backgroundColor: Colors.transparent,
      );
    }

    //if offline and has image
    if (response == 'off' && imagePath != '') {
      CircleAvatar(
        radius: (screenHeight - statusbarHeight) * 0.035,
        backgroundImage: FileImage(File(imagePath)),
        backgroundColor: Colors.transparent,
      );
    }
    return Icon(
      Icons.account_circle_outlined,
      size: (screenHeight - statusbarHeight) * 0.07,
    );
  }

  final appBar = AppBar();

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUser(widget.userKey);
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

    //user

    final user = userProvider.userData;
    final userName = user.userName;
    final userSchoolId = user.schoolId;
    final userCourse = user.userCourse;
    final userYear = user.userYear;
    final isAdmin = user.isAdmin;
    final userPassword = user.userPassword;
    final userProfile = user.userProfile;
    final isSignUpOnline = user.isSignupOnline;

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
                                  user.userName,
                                  userCourse,
                                  userYear,
                                  userPassword,
                                  isAdmin,
                                  userProfile,
                                  isSignUpOnline),
                              child: Consumer<UsersProvider>(
                                builder: (context, provider, child) {
                                  final userImage = provider.userImage;

                                  return SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        userImage != null
                                            ? showProfile(
                                                userProfile,
                                                userImage,
                                                screenHeight,
                                                statusbarHeight)
                                            : const SizedBox.shrink(),
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
                                  );
                                },
                              )),
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
                                user.userName,
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
                user.userName,
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
