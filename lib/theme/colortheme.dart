import 'package:flutter/material.dart';

class ColorThemeProvider {
  int hexColor(String color) {
    String newColor = '0xff' + color;

    newColor = newColor.replaceAll("#", '');

    int finalColor = int.parse(newColor);

    return finalColor;
  }

  final primaryColor = '#6C63FF';

  final Color secondaryColor = Colors.white;
}
