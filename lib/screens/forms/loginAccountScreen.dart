import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/utils/formUtils/TextParagraphResponsive.dart';
import 'package:qr_app/utils/formUtils/buttonResponsive.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/formUtils/formHeadersResponsive.dart';
import 'package:qr_app/utils/formUtils/passwordTextField.dart';
import 'package:qr_app/screens/menuscreen.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/utils/formUtils/textHeadingResponsive.dart';
import 'package:qr_app/utils/formUtils/textSubtitleResposive.dart';
import 'package:qr_app/utils/toast.dart';

class LoginScreenAccount extends StatefulWidget {
  final Color textColor;
  final double width;
  final double height;
  final Color textColorWhite;

  const LoginScreenAccount(
      {super.key,
      required this.textColor,
      required this.width,
      required this.textColorWhite,
      required this.height});

  @override
  State<LoginScreenAccount> createState() => _LoginScreenAccountState();
}

class _LoginScreenAccountState extends State<LoginScreenAccount> {
  final _nameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isVisible = true;

  //users database
  late Box<UsersType> _usersBox;
  final usersdb = UsersDatabase();

  @override
  void initState() {
    _usersBox = usersdb.UsersDatabaseInitialization();
    super.initState();
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  //toast
  final toast = CustomToast();

  //login user
  void userValidate() {
    final name = _usersBox.containsKey(_schoolIdController.text.trim());

    if (!name) {
      toast.userNotExist(context);
      return;
    }

    final user = _usersBox.get(_schoolIdController.text.trim());

    if (user!.userPassword != _passwordController.text) {
      toast.passwordIncorrect(context);
      return;
    }

    if (user.schoolId != int.parse(_schoolIdController.text)) {
      toast.userIdNotCorrect(context);
      return;
    }

    toast.loginSuccessfully(context, user.userName);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MenuScreen(
              userKey: _schoolIdController.text.trim(),
            )));
  }

  @override
  void dispose() {
    _nameController.clear();
    _passwordController.clear();
    _schoolIdController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextParagraphResponsive(
            color: widget.textColor, height: widget.height, text: 'LSG'),
        TextHeadingResponsive(
            color: Colors.black, height: widget.height, text: 'Welcome Back'),
        TextSubtitleResponsive(
            color: Colors.grey.shade500,
            height: widget.height,
            text: 'Glad to see you again'),
        TextSubtitleResponsive(
            color: Colors.grey.shade500,
            height: widget.height,
            text: 'Login to your account below'),
        Padding(
          padding: EdgeInsets.fromLTRB(
              40.0, widget.height >= 900 ? 40.0 : 4.0, 40.0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHeadersResponsive(
                  color: Colors.black, height: widget.height, text: 'Name'),
              CustomTextField(
                  height: widget.height,
                  isReadOnly: false,
                  keyBoardType: TextInputType.text,
                  hintext: 'enter name',
                  controller: _nameController),
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
                  text: 'School Id'),
              CustomTextField(
                  height: widget.height,
                  isReadOnly: false,
                  keyBoardType: TextInputType.number,
                  hintext: 'enter school id',
                  controller: _schoolIdController),
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
                  obscureText: isVisible,
                  isVisible: toggleVisibility)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 14.0, 40.0, 10),
            child: GestureDetector(
                onTap: userValidate,
                child: ButtonResponsive(
                    buttonColor: widget.textColor,
                    height: widget.height,
                    text: 'Login',
                    textColor: widget.textColorWhite,
                    width: widget.width))),
      ],
    );
  }
}
