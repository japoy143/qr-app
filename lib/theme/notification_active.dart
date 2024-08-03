import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationActive extends StatelessWidget {
  final double height;
  final double width;
  const NotificationActive(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/imgs/notification_active.svg',
      height: height,
      width: width,
    );
  }
}
