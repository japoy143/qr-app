import 'package:flutter/material.dart';
import 'package:qr_app/theme/avartar.dart';
import 'package:qr_app/theme/colortheme.dart';

class landingScreenWidget extends StatelessWidget {
  final double screenHeight;
  final double height;
  final double width;
  final color = ColorThemeProvider();

  landingScreenWidget({
    super.key,
    required this.screenHeight,
    required this.height,
    required this.width,
  });

  double textHeadingSizes(double height) {
    if (height >= 900) {
      return 30.0;
    }

    if (height < 900 && height >= 700) {
      return 26.0;
    }

    return 24.0;
  }

  double textSizes(double height) {
    if (height >= 900) {
      return 12.0;
    }

    if (height < 900 && height >= 700) {
      return 10.0;
    }

    return 8.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
              child: AvatarIllustration(height: height, width: width),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QR Codes\nEffortless Attedance',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: textHeadingSizes(screenHeight),
                  fontWeight: FontWeight.bold,
                  color: Color(color.hexColor(color.primaryColor))),
            ),
            Text(
              'Revolutionizing Attendance Tracking with Seamless \nQR Code Integration.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: textSizes(screenHeight),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
