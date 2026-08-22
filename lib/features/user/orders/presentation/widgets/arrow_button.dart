
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/services/others/page_navigation_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PageNavigationService.back(context),
      child: Container(
        height: 38.h(context),
        width: 38.w(context),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CrashSafeImage(
            Assets.icons.arrow.path,
            height: 18.h(context),
            width: 18.w(context),
            color: const Color(0xff6E6E6E),
          ),
        ),
      ),
    );
  }
}