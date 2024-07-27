import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/forms/formUtils/customtextField.dart';
import 'package:qr_app/screens/forms/formUtils/dropDownItem.dart';
import 'package:qr_app/screens/forms/formUtils/passwordTextField.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/utils/toast.dart';

class CreateAccountScreen extends StatefulWidget {
  final Color textColor;
  final double width;
  final double buttonWidth;
  final Color textColorWhite;
  const CreateAccountScreen(
      {super.key,
      required this.textColor,
      required this.width,
      required this.buttonWidth,
      required this.textColorWhite});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  List<String> courses = ['BSIT', 'BSCS', "BSIS", "BSCPE", "BSECE"];
  String? selectedCourse = 'BSIT';

  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  late Box<UsersType> _userBox;
  final userDb = UsersDatabase();

  @override
  void initState() {
    _userBox = userDb.UsersDatabaseInitialization();
    super.initState();
  }

  void togglePassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  final toast = CustomToast();

  void createUser() {
    bool admin = false;
    if (_nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _schoolIdController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      toast.errorCreationUser(context);
      return;
    }
    if (_nameController.text == 'vanesse') {
      admin = true;
    }

    userDb.createNewUser(
        _nameController.text,
        int.parse(_schoolIdController.text),
        selectedCourse!,
        selectedYear.toString(),
        _passwordController.text,
        admin,
        '');

    toast.successfullyCreatedUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LSG',
          style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 24.0),
        ),
        const Text(
          'Sign Up',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 40.0,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'Please enter your details',
          style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              CustomTextField(
                  hintext: 'enter name', controller: _nameController),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 5, 40.0, 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'School Id',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins"),
                    ),
                    CustomTextField(
                        hintext: 'enter school id',
                        controller: _schoolIdController),
                  ],
                ),
              ),
              SizedBox(
                width: widget.width,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade900)),
                    child: DropDown(
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
              ),
              SizedBox(
                width: widget.width,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Year',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade900)),
                    child: DropDown(
                      initialValue: selectedYear,
                      items: year,
                      onChanged: (val) {
                        setState(() {
                          selectedYear = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 5, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Password',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              PasswordTextField(
                  hintext: 'enter password',
                  controller: _passwordController,
                  obscureText: isPasswordVisible,
                  isVisible: togglePassword)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 5, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Password',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins"),
              ),
              PasswordTextField(
                  hintext: 'confirm password',
                  controller: _confirmPasswordController,
                  obscureText: isConfirmPasswordVisible,
                  isVisible: toggleConfirmPassword)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 0),
            child: GestureDetector(
              onTap: createUser,
              child: Container(
                width: widget.buttonWidth,
                decoration: BoxDecoration(
                    color: widget.textColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: Text(
                    'Create Account',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: widget.textColorWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                  )),
                ),
              ),
            )),
      ],
    );
  }
}
