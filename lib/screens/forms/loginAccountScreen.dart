import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/users.dart';
import 'package:qr_app/screens/forms/formUtils/customtextField.dart';
import 'package:qr_app/screens/forms/formUtils/passwordTextField.dart';
import 'package:qr_app/screens/homescreen.dart';
import 'package:qr_app/screens/menuscreen.dart';
import 'package:qr_app/services/usersdatabase.dart';
import 'package:qr_app/utils/toast.dart';

class LoginScreenAccount extends StatefulWidget {
  final Color textColor;
  final double width;
  final Color textColorWhite;

  const LoginScreenAccount({
    super.key,
    required this.textColor,
    required this.width,
    required this.textColorWhite,
  });

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

  void userValidate() {
    final name = _usersBox.containsKey(_nameController.text);

    if (!name) {
      toast.userNotExist(context);
      return;
    }

    final user = _usersBox.get(_nameController.text);

    if (user!.userPassword != _passwordController.text) {
      toast.passwordIncorrect(context);
      return;
    }

    toast.loginSuccessfully(context, user.userName);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          'Welcome Back',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 40.0,
              fontWeight: FontWeight.w600),
        ),
        Text(
          'Glad to see you again',
          style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14.0),
        ),
        Text(
          'Login to your account below',
          style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14.0),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 45.0, 40.0, 10),
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
                  hintext: 'enter school id', controller: _schoolIdController),
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
                  obscureText: isVisible,
                  isVisible: toggleVisibility)
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 10),
            child: GestureDetector(
              onTap: userValidate,
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                    color: widget.textColor,
                    borderRadius: BorderRadius.circular(6.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                      child: Text(
                    'Login',
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
