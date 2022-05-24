import 'package:flutter/material.dart';
import 'package:location_picker/plugin_colors.dart';

enum TStyle {
  h1_700,
  h1_600,
  h1_400,
  h2_700,
  h2_600,
  h2_400,
  h3_700,
  h3_600,
  h3_400,
  h4_700,
  h4_600,
  h4_400,
  h5_700,
  h5_600,
  h5_400,
  b1_700,
  b1_600,
  b1_400,
  b2_700,
  b2_600,
  b2_400,
  b3_700,
  b3_600,
  b3_400
}

class CfTextStyles {
  static late Map<TStyle, TextStyle> textStyleMap;
  static const font = 'RobotoRegular';

  static TextStyle? getTextStyle(
    TStyle style, {
    TextStyle? customStyle,
  }) {
    textStyleMap = CfTextStyles.mobTextStyle;
    return customStyle != null
        ? textStyleMap[style]!.merge(customStyle)
        : textStyleMap[style];
  }

  static final Map<TStyle, TextStyle> mobTextStyle = {
    TStyle.h1_700: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: PluginColors.black,
    ),
    TStyle.h1_600: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: PluginColors.black,
    ),
    TStyle.h1_400: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: PluginColors.black,
    ),
    TStyle.h2_700: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: PluginColors.black,
    ),
    TStyle.h2_600: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.h2_400: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.h3_700: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.h3_600: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.h3_400: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.h4_700: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.h4_600: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.h4_400: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.h5_700: const TextStyle(
      fontFamily: font,
      fontSize: 16,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.h5_600: const TextStyle(
      fontFamily: font,
      fontSize: 16,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.h5_400: const TextStyle(
      fontFamily: font,
      fontSize: 16,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.b1_700: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.b1_600: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.b1_400: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.b2_700: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.b2_600: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.b2_400: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
    TStyle.b3_700: const TextStyle(
      fontFamily: font,
      fontSize: 10,
      color: PluginColors.black,
      fontWeight: FontWeight.w700,
    ),
    TStyle.b3_600: const TextStyle(
      fontFamily: font,
      fontSize: 10,
      color: PluginColors.black,
      fontWeight: FontWeight.w600,
    ),
    TStyle.b3_400: const TextStyle(
      fontFamily: font,
      fontSize: 10,
      color: PluginColors.black,
      fontWeight: FontWeight.w400,
    ),
  };

  static final Map<TStyle, TextStyle> tabTextStyle = {
    TStyle.h1_700: const TextStyle(
      fontFamily: font,
      fontSize: 32,
      color: PluginColors.black,
    ),
    TStyle.h1_600: const TextStyle(
      fontFamily: font,
      fontSize: 32,
      color: PluginColors.black,
    ),
    TStyle.h1_400: const TextStyle(
      fontFamily: font,
      fontSize: 32,
      color: PluginColors.black,
    ),
    TStyle.h2_700: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      color: PluginColors.black,
    ),
    TStyle.h2_600: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      color: PluginColors.black,
    ),
    TStyle.h2_400: const TextStyle(
      fontFamily: font,
      fontSize: 28,
      color: PluginColors.black,
    ),
    TStyle.h3_700: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      color: PluginColors.black,
    ),
    TStyle.h3_600: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      color: PluginColors.black,
    ),
    TStyle.h3_400: const TextStyle(
      fontFamily: font,
      fontSize: 24,
      color: PluginColors.black,
    ),
    TStyle.h4_700: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
    ),
    TStyle.h4_600: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
    ),
    TStyle.h4_400: const TextStyle(
      fontFamily: font,
      fontSize: 20,
      color: PluginColors.black,
    ),
    TStyle.h5_700: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
    ),
    TStyle.h5_600: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
    ),
    TStyle.h5_400: const TextStyle(
      fontFamily: font,
      fontSize: 18,
      color: PluginColors.black,
    ),
    TStyle.b1_700: const TextStyle(
      fontFamily: font,
      fontSize: 16,
      color: PluginColors.black,
    ),
    TStyle.b1_600: const TextStyle(
      fontFamily: font,
      color: PluginColors.black,
    ),
    TStyle.b1_400: const TextStyle(
      fontFamily: font,
      fontSize: 16,
      color: PluginColors.black,
    ),
    TStyle.b2_700: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
    ),
    TStyle.b2_600: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
    ),
    TStyle.b2_400: const TextStyle(
      fontFamily: font,
      fontSize: 14,
      color: PluginColors.black,
    ),
    TStyle.b3_700: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
    ),
    TStyle.b3_600: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
    ),
    TStyle.b3_400: const TextStyle(
      fontFamily: font,
      fontSize: 12,
      color: PluginColors.black,
    ),
  };
}
