import 'package:flutter/material.dart';

class TextHeadingResponsive extends StatelessWidget {
  final Color color;
  final double height;
  final String text;
  const TextHeadingResponsive(
      {super.key,
      required this.color,
      required this.height,
      required this.text});
  double textSizes(double height) {
    if (height >= 900) {
      return 40.0;
    }

    if (height <= 900) {
      return 34.0;
    }

    return 28.0;
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
