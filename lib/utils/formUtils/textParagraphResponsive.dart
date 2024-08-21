import 'package:flutter/material.dart';

class TextParagraphResponsive extends StatelessWidget {
  final Color color;
  final double height;
  final String text;
  const TextParagraphResponsive(
      {super.key,
      required this.color,
      required this.height,
      required this.text});

  double responsiveTextSizing(
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
  //responsive condition

  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: responsiveTextSizing(height, 24.0, 20.0, 20.0, 18.0)),
    );
  }
}
