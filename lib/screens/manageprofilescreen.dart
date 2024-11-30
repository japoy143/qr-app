import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/formUtils/formHeadersResponsive.dart';
import 'package:qr_app/utils/formUtils/passwordTextField.dart';

class ManageProfileScreen extends StatefulWidget {
  final UsersType user;
  const ManageProfileScreen({super.key, required this.user});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  List<String> courses = ['BSIT', 'BSCS', "BSIS", "BSCPE", "BSECE"];

  List<int> year = [1, 2, 3, 4];
  late String? selectedCourse;
  late int? selectedYear;
  bool passwordVisible = true;

  double responsiveDropDownSizing(
      double height, double xlarge, double large, double medium, double small) {
    //if screen is xlarge
    if (height >= 900) {
      return xlarge;
    }

    //if screen is large
    if (height < 900 && height >= 800) {
      return large;
    }

    //if screen is medium
    if (height < 800 && height >= 700) {
      return medium;
    }

    //default small
    return small;
  }

  final String? secret_key = dotenv.env['secret_key'];

  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _middleInitialController;
  late TextEditingController _schoolIdController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.user.userName);
    _lastnameController = TextEditingController(text: widget.user.lastName);
    _middleInitialController =
        TextEditingController(text: widget.user.middleInitial);
    _schoolIdController =
        TextEditingController(text: widget.user.schoolId.toString());
    _passwordController = TextEditingController(
        text:
            Cipher(secretKey: secret_key).xorDecode(widget.user.userPassword));
    selectedCourse = widget.user.userCourse;
    selectedYear = int.parse(widget.user.userYear);
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _middleInitialController.dispose();
    _schoolIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Cipher cipher = Cipher(secretKey: secret_key);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 28, 14, 0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Account Details',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey.shade400,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: FormHeadersResponsive(
                color: Colors.black,
                height: screenHeight,
                text: 'First Name',
              ),
            ),
            CustomTextField(
                hintext: 'enter first name',
                controller: _firstnameController,
                keyBoardType: TextInputType.text,
                isReadOnly: false,
                height: screenHeight),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: FormHeadersResponsive(
                color: Colors.black,
                height: screenHeight,
                text: 'Last Name',
              ),
            ),
            CustomTextField(
                hintext: 'enter last name',
                controller: _lastnameController,
                keyBoardType: TextInputType.text,
                isReadOnly: false,
                height: screenHeight),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: FormHeadersResponsive(
                color: Colors.black,
                height: screenHeight,
                text: 'Middle Initial',
              ),
            ),
            CustomTextField(
                hintext: 'enter middle initial',
                controller: _middleInitialController,
                keyBoardType: TextInputType.text,
                isReadOnly: false,
                height: screenHeight),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            child: FormHeadersResponsive(
                              color: Colors.black,
                              height: screenHeight,
                              text: 'Password',
                            ),
                          ),
                          PasswordTextField(
                              hintext: 'enter password',
                              controller: _passwordController,
                              obscureText: passwordVisible,
                              isVisible: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              screenHeight: screenHeight),
                        ],
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormHeadersResponsive(
                          color: Colors.black,
                          height: screenHeight,
                          text: 'Courses'),
                      Container(
                        padding: EdgeInsets.all(responsiveDropDownSizing(
                            screenHeight, 7.0, 6.0, 4.0, 0.0)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade900)),
                        child: DropDown(
                          showUnderline: false,
                          initialValue: selectedCourse,
                          items: courses,
                          onChanged: (val) {
                            setState(() {
                              selectedCourse = val;
                            });
                          },
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormHeadersResponsive(
                          color: Colors.black,
                          height: screenHeight,
                          text: 'Year'),
                      Container(
                        padding: EdgeInsets.all(responsiveDropDownSizing(
                            screenHeight, 7.0, 6.0, 4.0, 0.0)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade900)),
                        child: DropDown(
                          initialValue: selectedYear,
                          showUnderline: false,
                          items: year,
                          onChanged: (val) {
                            setState(() {
                              selectedYear = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 70,
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final provider =
                          Provider.of<UsersProvider>(context, listen: false);

                      await provider.updateManageProfile(
                          int.parse(_schoolIdController.text),
                          selectedCourse.toString(),
                          selectedYear.toString(),
                          _firstnameController.text,
                          _lastnameController.text,
                          _middleInitialController.text,
                          _passwordController.text);

                      await provider.getUser(_schoolIdController.text);

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(4)),
                      height: 40,
                      width: 70,
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
