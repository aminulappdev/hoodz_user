import 'package:flutter/material.dart';

import 'dark_theme_colors.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';

class MyStyles {
  static Color _labelColor(bool isLightTheme) => isLightTheme
      ? LightThemeColors.labelTextColor
      : DarkThemeColors.labelTextColor;

  static Color _bodyColor(bool isLightTheme) => isLightTheme
      ? LightThemeColors.bodyTextColor
      : DarkThemeColors.bodyTextColor;

  static Color _titleColor(bool isLightTheme) => isLightTheme
      ? LightThemeColors.titleTextColor
      : DarkThemeColors.titleTextColor;

  ///icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: isLightTheme
            ? LightThemeColors.iconColor
            : DarkThemeColors.iconColor, 
      );

  ///app bar theme
  // static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
  //     AppBarTheme(
  //       elevation: 0,

  //       titleTextStyle: getTextTheme(
  //         isLightTheme: isLightTheme,
  //       ).headlineMedium!.copyWith(fontSize: MyFonts.appBarTittleSize),
  //       iconTheme: IconThemeData(
  //         color: isLightTheme
  //             ? LightThemeColors.iconColor
  //             : DarkThemeColors.iconColor,
  //       ),
  //       backgroundColor: isLightTheme
  //           ? LightThemeColors.scaffoldBackgroundColor
  //           : DarkThemeColors.scaffoldBackgroundColor,
  //       systemOverlayStyle: SystemUiOverlayStyle(
  //         statusBarColor: LightThemeColors.scaffoldBackgroundColor,
  //         statusBarIconBrightness: Brightness.dark,
  //         statusBarBrightness: Brightness.dark,
  //       ),
  //     );

  ///text theme
  static TextTheme getTextTheme({required bool isLightTheme}) {
    final appFontFamily = MyFonts.appFontFamily;

    return TextTheme(
      displayLarge: MyFonts.displayTextStyle.copyWith(
        fontSize: MyFonts.heroLarge,
        color: _titleColor(isLightTheme),
        height: 1.2,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineLarge: MyFonts.displayTextStyle.copyWith(
        fontSize: MyFonts.headlineLarge,
        color: _titleColor(isLightTheme),
        height: 1.25,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: MyFonts.displayTextStyle.copyWith(
        fontSize: MyFonts.headlineMedium,
        color: _titleColor(isLightTheme),
        height: 1.3,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: MyFonts.labelTextStyle.copyWith(
        fontSize: MyFonts.primaryButtonTextSize,
        color: _labelColor(isLightTheme),
        height: 1.5,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.32,
      ),
      bodyMedium: MyFonts.bodyTextStyle.copyWith(
        fontSize: MyFonts.bodyMediumSize,
        color: _bodyColor(isLightTheme),
        height: 1.5,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
    ).apply(fontFamily: appFontFamily);
  }
}
