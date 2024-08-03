import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final double fontsize;
  final double padding;
  final Function()? onpress;
  final String text;
  const CustomTextButton(
      {super.key,
      required this.onpress,
      required this.color,
      required this.text,
      required this.textColor,
      required this.fontsize,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontFamily: 'Poppins',
              fontSize: fontsize,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}