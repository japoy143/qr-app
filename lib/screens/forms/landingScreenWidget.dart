import 'package:flutter/material.dart';
import 'package:qr_app/theme/avartar.dart';
import 'package:qr_app/theme/colortheme.dart';

class landingScreenWidget extends StatelessWidget {
  final double height;
  final double width;
  final color = ColorThemeProvider();

  landingScreenWidget({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Color(color.hexColor(color.primaryColor))),
            ),
            Text(
              'Revolutionizing Attendance Tracking with Seamless \nQR Code Integration.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ],
    );
  }
}
