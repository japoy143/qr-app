import 'package:flutter/material.dart';

class circleButtonWidget extends StatelessWidget {
  final color;
  final double elevation;
  final Function()? ontap;
  const circleButtonWidget(
      {super.key,
      required this.color,
      required this.elevation,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Material(
        elevation: elevation,
        shape: CircleBorder(),
        color: color,
        child: Container(
          height: 60,
          width: 60,
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
