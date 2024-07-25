import 'package:flutter/material.dart';
import 'package:qr_app/screens/forms/carouselWidget.dart';
import 'package:qr_app/screens/forms/circleButtonWidget.dart';
import 'package:qr_app/screens/forms/createAccountScreen.dart';
import 'package:qr_app/screens/forms/landingScreenWidget.dart';
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

  @override
  Widget build(BuildContext context) {
    double appBarHeight = appBar.preferredSize.height;
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    Color purple = Color(color.hexColor(color.primaryColor));
    List pages = [
      landingScreenWidget(
        height: (screenHeight - appBarHeight - statusbarHeight) * 0.50,
        width: screenWIdth * 0.80,
      ),
      CreateAccountScreen()
    ];

    List Buttons = [circleButtonWidget(color: purple)];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '    LSG',
          style: TextStyle(
              color: Color(color.hexColor(color.primaryColor)),
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins'),
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 5, child: pages[pageIndex]),
          Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 44.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CarouselWidget(pageIndex: pageIndex, color: purple),
                    Buttons[pageIndex],
                  ],
                ),
              ))
        ],
      ),
    );
  }
}


// 107.80





