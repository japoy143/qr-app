import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/theme/colortheme.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/validationscreen/validationusers.dart';

class ValidationScreen extends StatefulWidget {
  final String userKey;
  const ValidationScreen({super.key, required this.userKey});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int totalEvent = 0;
  final TextEditingController _studentNameController = TextEditingController();

  List<String> courses = ['BSIT', 'BSCS', 'BSIS', 'BSCPE', 'BSECE'];
  String? selectedCourse = 'BSIT';

  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  //color theme
  final colortheme = ColorThemeProvider();

  @override
  void initState() {
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    Provider.of<UsersProvider>(context, listen: false).getUserImageList();
    _studentNameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final appBar = AppBar();

  List<Widget> circles() {
    var random =
        Random(); // Moved outside to avoid recreating the Random object

    return List.generate(15, (index) {
      double topPos = random.nextDouble() * 40;
      double leftPos = random.nextDouble() * 300;

      return Positioned(
        top: topPos,
        left: leftPos,
        child: SvgPicture.asset(
          'assets/imgs/circle.svg',
          height: index % 2 == 0
              ? 100
              : 40, // Add constraints like height/width if necessary
          width: index % 2 == 0 ? 100 : 40,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(colortheme.hexColor(colortheme.primaryColor));

    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        //users
        List<UsersType> allUsers = provider.userList;

        //sort user from admin, representative,  and  normal users
        List<UsersType> sortedUsers = allUsers
            .where((student) =>
                student.isAdmin == false && student.isValidationRep == false)
            .toList();

        sortedUsers.sort((a, b) => a.lastName.compareTo(b.lastName));

        sortedUsers.sort((a, b) => a.isUserValidated ? 1 : 0);
        //imageList
        final imageList = provider.userImageList;

        // Filter users by selected course and exclude admins
        final userAttendanceList = sortedUsers
            .where((student) =>
                student.userCourse == selectedCourse && student.isAdmin != true)
            .toList();

        // Further filter by selected year
        final sortedCoursesAndYear = userAttendanceList
            .where((student) => student.userYear == selectedYear.toString())
            .toList();

        // Search by student name
        final usersList = _studentNameController.text.isEmpty
            ? sortedCoursesAndYear
            : sortedCoursesAndYear
                .where((student) => student.userName
                    .toLowerCase()
                    .contains(_studentNameController.text.toLowerCase()))
                .toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Validation Accounts',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'users validation account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade400,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        height: screenHeight,
                        hintext: 'enter student name',
                        controller: _studentNameController,
                        keyBoardType: TextInputType.text,
                        isReadOnly: false,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: DropDown(
                        initialValue: selectedCourse,
                        showUnderline: false,
                        items: courses,
                        onChanged: (val) {
                          setState(() {
                            selectedCourse = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: DropDown(
                        initialValue: selectedYear,
                        showUnderline: false,
                        items: year,
                        onChanged: (val) {
                          setState(() {
                            selectedYear = val as int?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                    flex: 4,
                    child: usersList.isEmpty
                        ? Center(
                            child: Text('Student Not Found'),
                          )
                        : ListView.builder(
                            itemCount: usersList.length,
                            itemBuilder: (context, index) {
                              final item = usersList.elementAt(index);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    item.isValidationOpen =
                                        !item.isValidationOpen;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: purple,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: ValidationUsers(
                                      isOpen: item.isValidationOpen,
                                      user: item,
                                      imageList: imageList,
                                    ),
                                  ),
                                ),
                              );
                            })),
              ],
            )),
          ),
        );
      },
    );
  }
}
