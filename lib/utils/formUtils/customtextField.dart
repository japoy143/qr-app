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
      // Wrap the TextField with a Container
      height: responsiveTextFieldSizing(
          height, 70, 55, 50, 45), // Set the height of the container
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
