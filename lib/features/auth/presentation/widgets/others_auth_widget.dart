import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/foundation.dart';
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
    final showAppleSignIn = defaultTargetPlatform == TargetPlatform.iOS;

    return Row(
      children: [
        Expanded(
          child: _SocialAuthButton(
            iconPath: Assets.icons.google.path,
            label: 'Google',
            onTap: onGooglePressed,
          ),
        ),
        if (showAppleSignIn) ...[
          SizedBox(width: 20.w(context)),
          Expanded(
            child: _SocialAuthButton(
              iconPath: Assets.icons.apple.path,
              label: 'Apple',
              onTap: onApplePressed,
            ),
          ),
        ],
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.iconPath,
    required this.label,
    this.onTap,
  });

  final String iconPath;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                iconPath,
                height: 20.h(context),
                width: 20.w(context),
              ),
              SizedBox(width: 8.w(context)),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF303030),
                  fontFamily: 'Geist',
                  fontSize: 16.sp(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
