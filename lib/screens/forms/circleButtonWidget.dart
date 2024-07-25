import 'package:flutter/material.dart';

class circleButtonWidget extends StatelessWidget {
  final color;
  const circleButtonWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Image.asset(
          'assets/imgs/Forward.png',
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
