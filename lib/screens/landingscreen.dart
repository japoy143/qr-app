import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/screens/forms/createAccountScreen.dart';
import 'package:qr_app/utils/formUtils/carouselWidget.dart';
import 'package:qr_app/utils/formUtils/circleButtonWidget.dart';
import 'package:qr_app/utils/formUtils/textButton.dart';
import 'package:qr_app/screens/forms/landingScreenWidget.dart';
import 'package:qr_app/screens/forms/loginAccountScreen.dart';
import 'package:qr_app/theme/colortheme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final color = ColorThemeProvider();
  final appBar = AppBar();
  int pageIndex = 0;

  void newScreen() {
    setState(() {
      if (pageIndex > 1) {
        pageIndex--;
      } else {
        pageIndex++;
      }
    });
  }

  //responsive screen sizes
  double responsiveScreenSizing(double height, double ratio, double xlarge,
      double large, double medium, double small) {
    //if screen is xlarge
    if (height >= 900) {
      return ratio * xlarge;
    }

    //if screen is large
    if (height < 900 && height >= 800) {
      return ratio * large;
    }

    //if screen is medium
    if (height < 800 && height >= 700) {
      return ratio * medium;
    }

    //default small
    return ratio * small;
  }

  double carouselResponsiveSizing(double height, double ratio, double xlarge,
      double large, double medium, double small) {
    //if screen is xlarge
    if (height >= 900) {
      return ratio * xlarge;
    }

    //if screen is large
    if (height < 900 && height >= 800) {
      return ratio * large;
    }

    //if screen is medium
    if (height < 800 && height >= 700) {
      return ratio * medium;
    }

    //default small
    return ratio * small;
  }

  double responsiveSizing(
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

  //render app if only the screen size is greaterthan 700
  bool isAppBarShown(double height, double screenHeight, double appBarHeight,
      double statusbarHeight) {
    if (height >= 900) {
      return true;
    }
    if (height < 900 && height >= 800) {
      return true;
    }

    if (height < 900 && height >= 700) {
      return false;
    }

    return false;
  }

  double avatarSizes(double height, double screenHeight, double appBarHeight,
      double statusbarHeight) {
    if (height >= 900) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.45;
    }

    if (height < 900 && height >= 700) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.45;
    }

    return ((screenHeight + statusbarHeight) - appBarHeight) * 0.40;
  }

  //appbar rendering
  AppBar? buildAppBar(double totalHeight, double screenHeight,
      double appBarHeight, double statusbarHeight) {
    if (!isAppBarShown(
        totalHeight, screenHeight, appBarHeight, statusbarHeight)) {
      // Conditions for hiding the AppBar
      if (pageIndex != 0 || totalHeight <= 600) return null;
    }

    // Common AppBar title
    final appBarTitle = pageIndex == 0
        ? Text(
            '    LSG',
            style: TextStyle(
              color: Color(color.hexColor(color.primaryColor)),
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
            ),
          )
        : const Text('');

    return AppBar(title: appBarTitle);
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    double totalheight = (appBarHeight + screenHeight + statusbarHeight);
    Color purple = Color(color.hexColor(color.primaryColor));

    //show appbar
    double showAppbar =
        ((screenHeight + statusbarHeight) - appBarHeight) * 0.80;

    //for ratio
    double ratio = ((screenHeight + statusbarHeight) - appBarHeight);

    List pages = [
      landingScreenWidget(
        screenHeight: totalheight,
        height: avatarSizes(
            totalheight, screenHeight, appBarHeight, statusbarHeight),
        width: screenWIdth * 0.80,
      ),
      LoginScreenAccount(
        height: (appBarHeight + screenHeight + statusbarHeight),
        textColor: purple,
        width: screenWIdth,
        textColorWhite: color.secondaryColor,
      ),
      CreateAccountScreen(
        height: (appBarHeight + screenHeight + statusbarHeight),
        textColorWhite: color.secondaryColor,
        textColor: purple,
        width: screenHeight * 0.02,
        buttonWidth: screenHeight * 0.80,
      )
    ];

    List Buttons = [
      circleButtonWidget(
        screenHeight: totalheight,
        color: purple,
        elevation: 6,
        ontap: newScreen,
      ),
      CustomTextButton(
        padding: responsiveSizing(totalheight, 12.0, 8.0, 8.0, 6.0),
        onpress: newScreen,
        color: purple,
        text: 'Create Account',
        textColor: color.secondaryColor,
        responsivePadding: responsiveSizing(totalheight, 10.0, 8.0, 8.0, 6.0),
        fontsize: responsiveSizing(totalheight, 14.0, 13.0, 12.0, 12.0),
      ),
      CustomTextButton(
          padding: responsiveSizing(totalheight, 12.0, 8.0, 8.0, 6.0),
          onpress: newScreen,
          fontsize: responsiveSizing(totalheight, 14.0, 13.0, 12.0, 12.0),
          color: purple,
          text: 'Already Have An Account',
          responsivePadding: responsiveSizing(totalheight, 10.0, 8.0, 8.0, 6.0),
          textColor: color.secondaryColor),
    ];

    return Scaffold(
      appBar:
          buildAppBar(totalheight, screenHeight, appBarHeight, statusbarHeight),
      body: Padding(
        padding: screenHeight >= 700 && pageIndex == 0
            ? const EdgeInsets.fromLTRB(20, 0, 20, 0)
            : pageIndex == 0
                ? const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0)
                : const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: totalheight < 850 && pageIndex == 0
                    ? showAppbar
                    : responsiveScreenSizing(
                        totalheight, ratio, 0.70, 0.80, 0.85, 0.90),
                child: pages[pageIndex],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isAppBarShown(screenHeight, screenHeight,
                            appBarHeight, statusbarHeight)
                        ? 44.0
                        : 8.0),
                child: SizedBox(
                  height: carouselResponsiveSizing(
                      totalheight, ratio, 0.20, 0.15, 0.15, 0.10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CarouselWidget(pageIndex: pageIndex, color: purple),
                      Buttons[pageIndex],
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
