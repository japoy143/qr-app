import 'package:flutter/material.dart';

class FormHeadersResponsive extends StatelessWidget {
  final Color color;
  final double height;
  final String text;
  const FormHeadersResponsive(
      {super.key,
      required this.color,
      required this.height,
      required this.text});
  double textSizes(double height) {
    if (height >= 900) {
      return 15.0;
    }

    if (height < 900 && height >= 600) {
      return 14.0;
    }

    return 10.0;
  }

  @override
  //responsive condition

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: textSizes(height)),
    );
  }
}
