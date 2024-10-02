import 'package:encrypt_decrypt_plus/cipher/cipher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/state/eventIdProvider.dart';
import 'package:qr_app/state/usersProvider.dart';
import 'package:qr_app/utils/formUtils/TextParagraphResponsive.dart';
import 'package:qr_app/utils/formUtils/buttonResponsive.dart';
import 'package:qr_app/utils/formUtils/customtextField.dart';
import 'package:qr_app/utils/formUtils/formHeadersResponsive.dart';
import 'package:qr_app/utils/formUtils/passwordTextField.dart';
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
  final String? secret_key = dotenv.env['secret_key'];

  bool isVisible = true;

  @override
  void initState() {
    try {
      Provider.of<UsersProvider>(context, listen: false).getAllAdminsAndSave();
    } catch (e) {}
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
  void userValidate(BuildContext context) async {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final eventIdProvider =
        Provider.of<EventIdProvider>(context, listen: false);
    final user = await userProvider.getUser(_schoolIdController.text.trim());
    Cipher cipher = Cipher(secretKey: secret_key);

    //check if user found or exist
    if (user == null) {
      Navigator.of(context).pop();
      toast.userNotExist(context);
      return;
    }

    //check if username is thesame
    if (user.userName != _nameController.text) {
      Navigator.of(context).pop();
      toast.usernameIncorrect(context);
      return;
    }

    // check if password is thesame with the encrypted password in database
    final decryptedPassword = cipher.xorDecode(user.userPassword);
    if (decryptedPassword != _passwordController.text) {
      Navigator.of(context).pop();
      toast.passwordIncorrect(context);
      return;
    }

    //check if id iis thesame
    if (user.schoolId != int.parse(_schoolIdController.text)) {
      Navigator.of(context).pop();
      toast.userIdNotCorrect(context);
      return;
    }

    // get user image url
    userProvider.getUserImage(_schoolIdController.text.trim());

    // off the progress bar
    Navigator.of(context).pop();
    //set status login to true
    await userProvider.login(
        user, int.parse((_schoolIdController.text.trim())));

    toast.loginSuccessfully(context, user.userName);
    userProvider.getUserImage(_schoolIdController.text.trim());

    //update user attendance & get all admins account save data
    try {
      userProvider.updateUserOfflineSaveData(
          int.parse(_schoolIdController.text.trim()));
      userProvider.getAllAdminsAndSave();
    } catch (e) {}

    eventIdProvider.setOfflineBoxToTrue();

    userProvider.getUser(_schoolIdController.text);
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
                  "Logging In...",
                  style: TextStyle(fontSize: 16), // Adjust font size if needed
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  color: Colors.black,
                  height: widget.height,
                  text: 'First name'),
              CustomTextField(
                  height: widget.height,
                  isReadOnly: false,
                  keyBoardType: TextInputType.text,
                  hintext: 'enter first name',
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
                onTap: () {
                  try {
                    showProgressDialog(context);
                    userValidate(context);
                  } catch (e) {
                    toast.errorCreationUser(context);
                  }
                },
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
