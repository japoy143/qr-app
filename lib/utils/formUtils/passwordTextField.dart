import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? isVisible;
  const PasswordTextField(
      {super.key,
      required this.hintext,
      required this.controller,
      required this.obscureText,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}
