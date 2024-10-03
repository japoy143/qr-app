import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/utils/formUtils/TextParagraphResponsive.dart';
import 'package:qr_app/utils/formUtils/buttonResponsive.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/formUtils/formHeadersResponsive.dart';
import 'package:qr_app/utils/formUtils/passwordTextField.dart';
import 'package:qr_app/utils/formUtils/textHeadingResponsive.dart';

import 'package:qr_app/utils/formUtils/textSubtitleResposive.dart';
import 'package:qr_app/utils/toast.dart';

class CreateAccountScreen extends StatefulWidget {
  final Color textColor;
  final double width;
  final double height;
  final double buttonWidth;
  final Color textColorWhite;
  const CreateAccountScreen(
      {super.key,
      required this.textColor,
      required this.height,
      required this.width,
      required this.buttonWidth,
      required this.textColorWhite});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  List<String> courses = ['BSIT', 'BSCS', "BSIS", "BSCPE", "BSECE"];
  String? selectedCourse = 'BSIT';

  List<int> year = [1, 2, 3, 4];
  int? selectedYear = 1;

  final toast = CustomToast();

  @override
  void initState() {
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

  void clearAllFields() {
    _nameController.clear();
    _lastNameController.clear();
    _middleInitialController.clear();
    _schoolIdController.clear();
    _courseController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  Future<bool> userValidation() async {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    if (_nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _schoolIdController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      toast.errorCreationUser(context);
      Navigator.of(context).pop();
      return false;
    }

    if (await userProvider.containsUser(int.parse(_schoolIdController.text))) {
      toast.userAlreadyExist(context);
      Navigator.of(context).pop();
      return false;
    }

    if (_passwordController.text.length < 8) {
      toast.passwordLengthError(context);
      Navigator.of(context).pop();
      return false;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      toast.passwordNotSame(context);
      Navigator.of(context).pop();
      return false;
    }
    userProvider.createNewUser(
        _nameController.text,
        _lastNameController.text,
        _middleInitialController.text,
        int.parse(_schoolIdController.text),
        selectedCourse.toString(),
        selectedYear.toString(),
        _passwordController.text.trim(),
        '');

    Navigator.of(context).pop();
    toast.successfullyCreatedUser(context);
    return true;
  }

  void createUser() async {
    if (await userValidation()) {
      clearAllFields();
    }
  }

  //progress bar
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
            width: 150, // Set a fixed width for the dialog
            child: Row(
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(
                    width: 16), // Reduce spacing between indicator and text
                Text(
                  "Signing Up...",
                  style: TextStyle(fontSize: 16), // Adjust font size if needed
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  double dropDownPadding(double height) {
    if (height >= 900) {
      return 8.0;
    }

    if (height < 900 && height >= 700) {
      return 6.0;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextParagraphResponsive(
            color: widget.textColor, height: widget.height, text: 'LSG'),
        TextHeadingResponsive(
            color: Colors.black, height: widget.height, text: 'Sign Up'),
        TextSubtitleResponsive(
            color: Colors.grey.shade500,
            height: widget.height,
            text: 'Please enter your details'),
        Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormHeadersResponsive(
                          color: Colors.black,
                          height: widget.height,
                          text: 'Name'),
                      CustomTextField(
                          height: widget.height,
                          isReadOnly: false,
                          hintext: 'enter name',
                          keyBoardType: TextInputType.text,
                          controller: _nameController),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormHeadersResponsive(
                          color: Colors.black,
                          height: widget.height,
                          text: 'Lastname'),
                      CustomTextField(
                          height: widget.height,
                          isReadOnly: false,
                          hintext: 'enter lastname',
                          keyBoardType: TextInputType.text,
                          controller: _lastNameController),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormHeadersResponsive(
                          color: Colors.black,
                          height: widget.height,
                          text: 'M.I'),
                      CustomTextField(
                          height: widget.height,
                          isReadOnly: false,
                          hintext: 'enter middle initial',
                          keyBoardType: TextInputType.text,
                          controller: _middleInitialController),
                    ],
                  ),
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 4, 40.0, 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormHeadersResponsive(
                        color: Colors.black,
                        height: widget.height,
                        text: 'School Id'),
                    CustomTextField(
                        height: widget.height,
                        isReadOnly: false,
                        hintext: 'enter school id',
                        keyBoardType: TextInputType.number,
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
                  FormHeadersResponsive(
                      color: Colors.black,
                      height: widget.height,
                      text: 'Courses'),
                  Container(
                    padding: EdgeInsets.all(responsiveDropDownSizing(
                        widget.height, 7.0, 6.0, 4.0, 0.0)),
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
              ),
              SizedBox(
                width: widget.width,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormHeadersResponsive(
                      color: Colors.black, height: widget.height, text: 'Year'),
                  Container(
                    padding: EdgeInsets.all(responsiveDropDownSizing(
                        widget.height, 7.0, 6.0, 4.0, 0.0)),
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 4, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHeadersResponsive(
                  color: Colors.black, height: widget.height, text: 'Password'),
              PasswordTextField(
                  screenHeight: widget.height,
                  hintext: 'enter password',
                  controller: _passwordController,
                  obscureText: isPasswordVisible,
                  isVisible: togglePassword)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 4, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHeadersResponsive(
                  color: Colors.black,
                  height: widget.height,
                  text: 'Confirm Password'),
              PasswordTextField(
                  screenHeight: widget.height,
                  hintext: 'confirm password',
                  controller: _confirmPasswordController,
                  obscureText: isConfirmPasswordVisible,
                  isVisible: toggleConfirmPassword)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 4.0, 40.0, 0),
            child: GestureDetector(
                onTap: () {
                  try {
                    showProgressDialog(context);
                    createUser();
                  } catch (e) {
                    toast.errorCreationUser(context);
                  }
                },
                child: ButtonResponsive(
                    buttonColor: widget.textColor,
                    height: widget.height,
                    text: 'Create Account',
                    textColor: widget.textColorWhite,
                    width: widget.buttonWidth))),
      ],
    );
  }
}
