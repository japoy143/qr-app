import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  double responsiveTextSizing(
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
    return Padding(
      padding: height >= 850
          ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
          : const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: height <= 850
                        ? const EdgeInsets.fromLTRB(0, 10, 30, 0)
                        : const EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: AvatarIllustration(height: height, width: width),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/imgs/cite_logo.png',
                      height: 60,
                      width: 60,
                      opacity: const AlwaysStoppedAnimation<double>(0.5),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QR Codes\nEffortless Attedance',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: responsiveTextSizing(
                        screenHeight, 30.0, 26.0, 26.0, 24.0),
                    fontWeight: FontWeight.bold,
                    color: Color(color.hexColor(color.primaryColor))),
              ),
              Text(
                'Revolutionizing Attendance Tracking with Seamless QR Code Integration.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: responsiveTextSizing(
                      screenHeight, 14.0, 12.0, 10.0, 10.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
