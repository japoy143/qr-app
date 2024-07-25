import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarIllustration extends StatelessWidget {
  final double height;
  final double width;
  const AvatarIllustration(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/imgs/illustration.svg',
      height: height,
      width: width,
    );
  }
}
