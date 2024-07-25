import 'package:flutter/material.dart';
import 'package:qr_app/screens/landingscreen.dart';
import 'package:qr_app/theme/colortheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorThemeProvider();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(color.hexColor(color.primaryColor))),
        useMaterial3: true,
      ),
      home: LandingScreen(),
    );
  }
}
