import 'package:flutter/material.dart';

class PageNavigationService { 
  static void to(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  static void replace(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void offAll(
    BuildContext context,
    String route, { 
    Map<String, dynamic>? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static void back(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }
}
