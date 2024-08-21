import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final double screenHeight;
  final String hintext;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? isVisible;
  const PasswordTextField(
      {super.key,
      required this.hintext,
      required this.controller,
      required this.obscureText,
      required this.isVisible,
      required this.screenHeight});

  double responsiveTextFieldSizing(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveTextFieldSizing(screenHeight, 70, 55, 45, 45),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: hintext,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: isVisible,
          ),
        ),
        controller: controller,
        obscureText: obscureText,
      ),
    );
  }
}
