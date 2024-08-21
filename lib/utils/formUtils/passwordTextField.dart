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

  double TextFieldSizes(double height) {
    if (height >= 900) {
      return 70;
    }

    if (height < 900 && height >= 700) {
      return 55;
    }

    if (height < 700 && height >= 600) {
      return 40;
    }

    return 30;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TextFieldSizes(screenHeight),
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
