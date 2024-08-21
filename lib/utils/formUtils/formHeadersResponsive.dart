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

  double responsiveTextHeaderSizing(
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
          fontSize: responsiveTextHeaderSizing(height, 15.0, 14.0, 14.0, 10.0)),
    );
  }
}
