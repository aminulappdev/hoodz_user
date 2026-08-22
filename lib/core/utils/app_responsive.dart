import 'package:flutter/material.dart';
import 'dart:ui' show FlutterView;

/// Global mobile-only responsive scaling utility.
///
/// Usage (via extension methods below — recommended):
/// ```dart
/// Text('Hello', style: TextStyle(fontSize: 16.sp(context)))
///
/// Container(
///   width: 200.w(context),
///   height: 100.h(context),
///   padding: EdgeInsets.all(12.r(context)),
/// )
/// ```
///
/// Notes:
/// - Use `.sp` / `.w` / `.r` for FONT SIZE, FIXED WIDTHS, PADDING, RADIUS,
///   ICON SIZE — i.e. anything that should scale proportionally with screen
///   width but isn't meant to fill available space.
/// - Use `.h` for FIXED HEIGHTS / VERTICAL SPACING (SizedBox, gaps, etc).
/// - Do NOT use these for full-width/flexible containers — use
///   `double.infinity`, `Expanded`, `Flexible`, or `LayoutBuilder` instead.
class AppResponsive {
  AppResponsive._();

  /// Design reference size — the screen size you designed your UI at
  /// (e.g. Figma frame size). Change these to match your design file.
  static const double _baseWidth = 440.0;
  static const double _baseHeight = 956.0;

  /// Clamp range — keeps scaling within +-15% so nothing gets
  /// absurdly small on tiny phones or absurdly large on big phones.
  static const double _minScale = 0.85;
  static const double _maxScale = 1.15;

  static FlutterView get _view =>
      WidgetsBinding.instance.platformDispatcher.views.first;

  static Size _size([BuildContext? context]) {
    if (context != null) {
      return MediaQuery.sizeOf(context);
    }

    return _view.physicalSize / _view.devicePixelRatio;
  }

  static double widthScale([BuildContext? context]) {
    final width = _size(context).width;
    return (width / _baseWidth).clamp(_minScale, _maxScale);
  }

  static double heightScale([BuildContext? context]) {
    final height = _size(context).height;
    return (height / _baseHeight).clamp(_minScale, _maxScale);
  }

  /// Font / icon size scaling (width based).
  static double sp(double size, [BuildContext? context]) =>
      size * widthScale(context);

  /// Horizontal dimension / spacing scaling.
  static double w(double size, [BuildContext? context]) =>
      size * widthScale(context);

  /// Vertical dimension / spacing scaling.
  static double h(double size, [BuildContext? context]) =>
      size * heightScale(context);

  /// Radius / padding scaling (width based).
  static double r(double size, [BuildContext? context]) =>
      size * widthScale(context);
}

/// Extension methods so you can write `16.sp(context)` instead of
/// `AppResponsive.sp(context, 16)`.
extension ResponsiveNumExt on num {
  double sp([BuildContext? context]) => AppResponsive.sp(toDouble(), context);
  double w([BuildContext? context]) => AppResponsive.w(toDouble(), context);
  double h([BuildContext? context]) => AppResponsive.h(toDouble(), context);
  double r([BuildContext? context]) => AppResponsive.r(toDouble(), context);
}
