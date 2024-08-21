import 'package:flutter/material.dart';
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

  //scree sizes for small to large
  double screenSizes(double height, double screenHeight, double appBarHeight,
      double statusbarHeight) {
    if (height >= 900) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.75;
    }

    if (height < 900 && height >= 800) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.80;
    }

    if (height < 800 && height >= 700) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.85;
    }

    return ((screenHeight + statusbarHeight) - appBarHeight) * 0.90;
  }

  //carousel sizes  for small to large
  double carouselSizes(double height, double screenHeight, double appBarHeight,
      double statusbarHeight) {
    if (height >= 900) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.20;
    }

    if (height < 900 && height >= 700) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.15;
    }

    return ((screenHeight + statusbarHeight) - appBarHeight) * 0.10;
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
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.55;
    }

    if (height < 900 && height >= 700) {
      return ((screenHeight + statusbarHeight) - appBarHeight) * 0.50;
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
        padding: 10.0,
        onpress: newScreen,
        color: purple,
        text: 'Create Account',
        textColor: color.secondaryColor,
        fontsize: 14.0,
      ),
      CustomTextButton(
          padding: 10.0,
          onpress: newScreen,
          fontsize: 13.0,
          color: purple,
          text: 'Already Have An Account',
          textColor: color.secondaryColor),
    ];

    return Scaffold(
      appBar:
          buildAppBar(totalheight, screenHeight, appBarHeight, statusbarHeight),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            0,
            isAppBarShown(
                    totalheight, screenHeight, appBarHeight, statusbarHeight)
                ? 0
                : pageIndex != 0
                    ? 40.0
                    : 0,
            0,
            0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: totalheight < 850 && pageIndex == 0
                    ? showAppbar
                    : screenSizes(totalheight, screenHeight, appBarHeight,
                        statusbarHeight),
                child: pages[pageIndex],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isAppBarShown(screenHeight, screenHeight,
                            appBarHeight, statusbarHeight)
                        ? 44.0
                        : 8.0),
                child: SizedBox(
                  height: carouselSizes(screenHeight, screenHeight,
                      appBarHeight, statusbarHeight),
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
