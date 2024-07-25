import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  const CustomTextField(
      {super.key, required this.hintext, required this.controller});

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
    );
  }
}
