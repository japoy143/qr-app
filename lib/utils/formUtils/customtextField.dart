import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool isReadOnly;
  const CustomTextField(
      {super.key,
      required this.hintext,
      required this.controller,
      required this.keyBoardType,
      required this.isReadOnly});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hintext,
      ),
      controller: controller,
      keyboardType: keyBoardType,
      readOnly: isReadOnly,
    );
  }
}
