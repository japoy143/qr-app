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

  double buttonSizes(double height) {
    if (height >= 900) {
      return 60.0;
    }

    if (height < 900 && height >= 700) {
      return 40.0;
    }

    if (height < 700 && height >= 600) {
      return 30.0;
    }

    return 20.0;
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
          height: buttonSizes(screenHeight),
          width: buttonSizes(screenHeight),
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
