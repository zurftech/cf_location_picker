import 'package:flutter/material.dart';

class PluginColors {
  PluginColors._();

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  static const Color primary = Color(0xFFD73326);
  static const Color secondry = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFbdbdbc);
  static const Color textGrey = Color(0xFF747474);

  static const Color black = Color(0xFF000000);
  static const Color lightGrey = Color(0xFFd3d3d3);

  static const Color green = Colors.green;
  static const Color red = Colors.red;
  static const Color white = Colors.white;

  static const Color whatsappGreen = Color(0xff25D366);

  static const Color transparent = Colors.transparent;
}
