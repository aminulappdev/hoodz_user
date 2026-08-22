import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'dark_theme_colors.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';
import 'my_styles.dart';

class MyTheme {
  static getThemeData({required bool isLight}) {
    final hintTextColor = isLight
        ? LightThemeColors.hintTextColor
        : DarkThemeColors.hintTextColor;
    final textTheme = MyStyles.getTextTheme(isLightTheme: isLight);

    return ThemeData(
      fontFamily: MyFonts.appFontFamily,
      // main color (app bar,tabs..etc)
      primaryColor: isLight
          ? LightThemeColors.primaryColor
          : DarkThemeColors.primaryColor,
      scaffoldBackgroundColor: isLight
          ? LightThemeColors.scaffoldBackgroundColor
          : DarkThemeColors.scaffoldBackgroundColor,
      // secondary & background color
      colorScheme:
          ColorScheme.fromSwatch(
            accentColor: isLight
                ? LightThemeColors.accentColor
                : DarkThemeColors.accentColor,
            backgroundColor: isLight
                ? LightThemeColors.backgroundColor
                : DarkThemeColors.backgroundColor,
            brightness: isLight ? Brightness.light : Brightness.dark,
          ).copyWith(
            secondary: isLight
                ? LightThemeColors.accentColor
                : DarkThemeColors.accentColor,
          ),

      // color contrast (if the theme is dark text should be white for example)
      brightness: isLight ? Brightness.light : Brightness.dark,

      // hint text color
      hintColor: hintTextColor,

      // progress bar theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isLight
            ? LightThemeColors.primaryColor
            : DarkThemeColors.primaryColor,
      ),

      // appBar theme
      // appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

      // text theme
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // input hint styling
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: hintTextColor, fontWeight: FontWeight.w400),
      ),

      // icon theme
      iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  static changeTheme() {
    // *) check if the current theme is light (default is light)
    bool isLightTheme = MySharedPref.isLightTheme();

    // *) store the new theme mode on get storage
    MySharedPref.setTheme(isLightTheme);

    // *) let GetX change theme
    Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  /// check if the theme is light or dark
  bool get getThemeIsLight => MySharedPref.isLightTheme();
}
