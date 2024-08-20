import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool isReadOnly;
  final double height; // New parameter for specifying the height

  const CustomTextField({
    super.key,
    required this.hintext,
    required this.controller,
    required this.keyBoardType,
    required this.isReadOnly,
    required this.height,
  });
  double TextFieldSizes(double height) {
    if (height >= 900) {
      return 100;
    }

    if (height <= 900) {
      return 70;
    }

    return 50;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Wrap the TextField with a Container
      height: TextFieldSizes(height), // Set the height of the container
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintText: hintext,
        ),
        controller: controller,
        keyboardType: keyBoardType,
        readOnly: isReadOnly,
      ),
    );
  }
}
