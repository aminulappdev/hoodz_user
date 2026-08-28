import 'package:flutter/material.dart';
import 'package:hoodz/app/translator/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;
  static bool _isInitialized = false;

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token'; 
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _accessToken = 'access_token';
  static const String _userIdKey = 'user_id';

  /// init get storage services 
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
    _isInitialized = true;
  }

  /// set theme current type as light theme
  static Future<void> setTheme(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool isLightTheme() => !_isInitialized
      ? true
      : _sharedPreferences.getBool(_lightThemeKey) ??
            true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setLocale(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// save authorization token
  static Future<void> setAccessToken(String token) =>
      _sharedPreferences.setString(_accessToken, token);

  /// save user id
  static Future<void> setUserId(String userId) =>
      _sharedPreferences.setString(_userIdKey, userId);

  /// get current locale
  static Locale getLocale() {
    if (!_isInitialized) {
      return const Locale('en');
    }

    String? langCode = _sharedPreferences.getString(_currentLocalKey);
    // default language is english
    return LocalizationService.supportedLanguages[langCode] ??
        const Locale('en');
  }

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// get authorization token
  static String? getAccessToken() =>
      _isInitialized ? _sharedPreferences.getString(_accessToken) : null;

  /// get user id
  static String? getUserId() =>
      _isInitialized ? _sharedPreferences.getString(_userIdKey) : null;

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();
}
