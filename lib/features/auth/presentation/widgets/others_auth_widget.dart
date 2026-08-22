import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class OthersAuth extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  const OthersAuth({super.key, this.onGooglePressed, this.onApplePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onGooglePressed,
            child: Container(
              height: 48.h(context),
              decoration: BoxDecoration(
                border: Border.all(
                  color: LightThemeColors.primaryColor,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(30.r(context)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrashSafeImage(
                      Assets.icons.google.path,
                      height: 20.h(context),
                      width: 20.w(context),
                    ),
                    SizedBox(width: 8.w(context)),
                    Text(
                      'Google',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF303030),
                        fontFamily: 'Geist',
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w(context)),
        Expanded(
          child: GestureDetector(
            onTap: onApplePressed,
            child: Container(
              height: 48.h(context),
              decoration: BoxDecoration(
                border: Border.all(
                  color: LightThemeColors.primaryColor,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(30.r(context)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrashSafeImage(
                      Assets.icons.apple.path,
                      height: 20.h(context),
                      width: 20.w(context),
                    ),
                    SizedBox(width: 8.w(context)),
                    Text(
                      'Apple',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Color(0xFF303030),
                        fontFamily: 'Geist',
                        fontSize: 16.sp(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}