import 'package:flutter/material.dart';

class AppConfig {
  static const appName = "Heart String";
  static const appTagline = "Find your perfect match";
  // ignore: non_constant_identifier_names
  static String APP_USER_ID = "";
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
