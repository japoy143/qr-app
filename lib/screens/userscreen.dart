import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/penaltyvalues.dart';
import 'package:qr_app/models/types.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/eventProvider.dart';
import 'package:qr_app/state/penaltyValues.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/generatePenaltyPdf.dart';
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
    String lastName,
    String middleInitial,
    String userCourse,
    String userYear,
    String userPassword,
    bool isAdmin,
    String userProfile,
    bool isSignUpOnline,
    bool isLogin,
    String eventAttended,
    bool isValidationRep,
    bool isUserValidated,
  ) async {
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
            lastName: lastName,
            middleInitial: middleInitial,
            userCourse: userCourse,
            userYear: userYear,
            userPassword: userPassword,
            isAdmin: isAdmin,
            userProfile: image.path,
            isSignupOnline: isSignUpOnline,
            isLogin: isLogin,
            eventAttended: eventAttended,
            isPenaltyShown: false,
            isValidationRep: isValidationRep,
            isUserValidated: isUserValidated));

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

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),

          // Adjust padding to make it more compact
          content: SizedBox(
            width: 150,
            child: Row(
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(
                    width: 16), // Reduce spacing between indicator and text
                Text(
                  "Logging Out...",
                  style: TextStyle(fontSize: 16), // Adjust font size if needed
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //user attended
  int getUserTotalAttended(String eventAttended) {
    List attend = eventAttended.split('|');

    int totalEventAttended = attend.length - 1;

    return totalEventAttended;
  }

  int getUserEventMissed(String eventAttended, int totalEvent) {
    List attend = eventAttended.split('|');

    int totalEventAttended = attend.length - 1;
    int eventMissed = totalEvent - totalEventAttended;

    return eventMissed;
  }

  final appBar = AppBar();

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUser(widget.userKey);
    Provider.of<EventIdProvider>(context, listen: false).getEventIdLength();
    Provider.of<EventProvider>(context, listen: false).getEvents();
    Provider.of<PenaltyValuesProvider>(context, listen: false)
        .getPenaltyValues();
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

    //user data
    UsersType user = userProvider.userData;

    //for qr data
    String qrData = [
      user.schoolId.toString(),
      "|",
      user.userName,
      "|",
      user.userCourse,
      "|",
      user.userYear
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
                                  user.schoolId,
                                  user.userName,
                                  user.lastName,
                                  user.middleInitial,
                                  user.userCourse,
                                  user.userYear,
                                  user.userPassword,
                                  user.isAdmin,
                                  user.userProfile,
                                  user.isSignupOnline,
                                  user.isLogin,
                                  user.eventAttended,
                                  user.isValidationRep,
                                  user.isUserValidated),
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
                                                user.userProfile,
                                                userImage,
                                                screenHeight,
                                                statusbarHeight)
                                            : Icon(
                                                Icons.account_circle_outlined,
                                                size: (screenHeight -
                                                        statusbarHeight) *
                                                    0.07,
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
                                "${user.userName} ${user.lastName}",
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                                '${user.isAdmin ? adminPosition.positions[user.schoolId] : "Student"}'),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: () async {
                          final userProvider = Provider.of<UsersProvider>(
                              context,
                              listen: false);
                          showProgressDialog(context);
                          await Future.delayed(Duration(seconds: 2), () {
                            userProvider.logout(user.schoolId);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                              fontSize: 16),
                        ))
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
                    child: user.isUserValidated
                        ? PrettyQrView.data(
                            data: qrData,
                            decoration: const PrettyQrDecoration())
                        : PrettyQrView.data(
                            data: '0|0|0|0',
                            decoration: const PrettyQrDecoration(
                              image: PrettyQrDecorationImage(
                                  image: AssetImage(
                                      'assets/imgs/validate_warn.png'),
                                  scale: 0.8),
                            )),
                  )),
              Text(
                user.userName,
                style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
              ),
              Text(
                '${user.userCourse}-${user.userYear}',
                style: const TextStyle(fontSize: 15, fontFamily: 'Poppins'),
              ),
              Padding(
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
                        child: Consumer<EventProvider>(
                            builder: (context, provider, child) {
                          final events = provider.eventList;

                          return Consumer<PenaltyValuesProvider>(
                            builder: (context, provider, child) {
                              List<PenaltyValues> penaltyValuesList =
                                  provider.penaltyList;

                              return GestureDetector(
                                  onTap: () async {
                                    SaveAndDownloadUserPdf.createPdf(
                                      users: user,
                                      events: events,
                                      penaltyValues: penaltyValuesList,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Attendance ',
                                        style: TextStyle(
                                            fontSize: 16, color: purple),
                                      ),
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: purple,
                                      )
                                    ],
                                  ));
                            },
                          );
                        }),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Consumer<EventIdProvider>(
                  builder: (context, provider, child) {
                    final totalEvent = provider.eventLength;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        EventSummary(
                            counter: '$totalEvent', eventName: 'TotalEvents'),
                        EventSummary(
                            counter: getUserTotalAttended(user.eventAttended)
                                .toString(),
                            eventName: 'Events Attended'),
                        EventSummary(
                            counter: getUserEventMissed(
                                    user.eventAttended, totalEvent)
                                .toString(),
                            eventName: 'Events Missed'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
