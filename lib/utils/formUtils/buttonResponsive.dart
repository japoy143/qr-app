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
  double textSizes(double height) {
    if (height >= 900) {
      return 18.0;
    }

    if (height <= 900) {
      return 16.0;
    }

    return 10.0;
  }

  double buttonSizes(double height) {
    if (height >= 900) {
      return 16.0;
    }

    if (height <= 900) {
      return 14.0;
    }

    return 8.0;
  }

  @override
  //responsive condition

  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: buttonSizes(height)),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Poppins',
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: textSizes(height)),
        )),
      ),
    );
  }
}
