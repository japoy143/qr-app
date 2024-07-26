import 'package:flutter/material.dart';
import 'package:qr_app/screens/forms/createAccountScreen.dart';
import 'package:qr_app/screens/forms/formUtils/carouselWidget.dart';
import 'package:qr_app/screens/forms/formUtils/circleButtonWidget.dart';
import 'package:qr_app/screens/forms/formUtils/textButton.dart';
import 'package:qr_app/screens/forms/landingScreenWidget.dart';
import 'package:qr_app/screens/forms/loginAccountScreen.dart';
import 'package:qr_app/theme/avartar.dart';
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

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(color.hexColor(color.primaryColor));
    List pages = [
      landingScreenWidget(
        height: (screenHeight - appBarHeight - statusbarHeight) * 0.55,
        width: screenWIdth * 0.80,
      ),
      LoginScreenAccount(
        textColor: purple,
        width: screenWIdth,
        textColorWhite: color.secondaryColor,
      ),
      CreateAccountScreen(
        textColorWhite: color.secondaryColor,
        textColor: purple,
        width: screenHeight * 0.02,
        buttonWidth: screenHeight * 0.80,
      )
    ];

    List Buttons = [
      circleButtonWidget(
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
      appBar: AppBar(
        title: pageIndex == 0
            ? Text(
                '    LSG',
                style: TextStyle(
                    color: Color(color.hexColor(color.primaryColor)),
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins'),
              )
            : const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: (screenHeight - appBarHeight - statusbarHeight) * 0.80,
              child: pages[pageIndex],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 44.0),
              child: SizedBox(
                height: (screenHeight - appBarHeight - statusbarHeight) * 0.20,
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
    );
  }
}
