import 'package:flutter/material.dart';

class ButtonResponsive extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final double height;
  final String text;
  final double width;
  const ButtonResponsive(
      {super.key,
      required this.buttonColor,
      required this.height,
      required this.text,
      required this.textColor,
      required this.width});

  double responsiveButtonSizing(
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
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: responsiveButtonSizing(height, 16.0, 14.0, 10.0, 8.0)),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Poppins',
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: responsiveButtonSizing(height, 18.0, 16.0, 16.0, 14.0)),
        )),
      ),
    );
  }
}
