import 'package:flutter/material.dart';

class circleButtonWidget extends StatelessWidget {
  final double screenHeight;
  final color;
  final double elevation;
  final Function()? ontap;
  const circleButtonWidget(
      {super.key,
      required this.screenHeight,
      required this.color,
      required this.elevation,
      required this.ontap});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Material(
        elevation: elevation,
        shape: CircleBorder(),
        color: color,
        child: Container(
          height: responsiveButtonSizing(screenHeight, 60.0, 45.0, 38.0, 30.0),
          width: responsiveButtonSizing(screenHeight, 60.0, 45.0, 38.0, 30.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/imgs/Forward.png',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ),
    );
  }
}
