import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationNone extends StatelessWidget {
  final double height;
  final double width;
  const NotificationNone(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/imgs/notification_none.svg',
      height: height,
      width: width,
    );
  }
}
