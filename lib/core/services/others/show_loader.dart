
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';


Future<void> showLoadingOverLay({
  required Future<void> Function() asyncFunction,
  String? msg,
}) async {
  await Get.showOverlay(
    asyncFunction: () async {
      try {
        await asyncFunction();
      } catch (e, stack) {
        Logger().e(e);
        Logger().e(stack);
      }
    },
    loadingWidget: Center(child: _getLoadingIndicator(msg: msg)),
    opacity: 0.7,
    opacityColor: Colors.black,
  );
}

Widget _getLoadingIndicator({String? msg}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
              color: LightThemeColors.backgroundColor,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          msg ?? 'Please wait',
          style: Get.textTheme.bodyLarge?.copyWith(
            color: LightThemeColors.backgroundColor,
          ),
        ),
      ],
    ),
  );
}
