import 'package:flutter/material.dart';
import 'package:hoodz/app/translator/localization_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/share_preference.dart';
 
// todo configure text family and size
class MyFonts {
  // Return the right font depending on app language.
  static TextStyle get getAppFontType => LocalizationService
      .supportedLanguagesFontsFamilies[MySharedPref.getLocale().languageCode]!;

  static String get appFontFamily =>
      getAppFontType.fontFamily ??
      LocalizationService.supportedLanguagesFontsFamilies['en']?.fontFamily ??
      'Poppins';

  // Font families by usage.
  static TextStyle get displayTextStyle => getAppFontType;

  // Body text font.
  static TextStyle get bodyTextStyle => getAppFontType;

  // Label text font.
  static TextStyle get labelTextStyle => getAppFontType;

  // Core typography scale.
  static double get heroLarge => AppResponsive.sp(32);
  static double get heroMedium => AppResponsive.sp(28);
  static double get headlineLarge => AppResponsive.sp(24);
  static double get headlineMedium => AppResponsive.sp(20);
  static double get bodyLarge => AppResponsive.sp(16);
  static double get bodyMedium => AppResponsive.sp(14);
  static double get caption => AppResponsive.sp(12);
  static double get chipSmall => AppResponsive.sp(10);

  // Backward-compatible aliases for existing usage.
  static double get appBarTittleSize => bodyLarge;
  static double get bodyMediumSize => bodyMedium;
  static double get primaryButtonTextSize => bodyLarge;
}
