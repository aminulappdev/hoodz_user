import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/routes/app_routes.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/app/translator/strings_enum.dart';

bool _isLoginDialogScheduled = false;

void showLoginRequiredDialog() {
  if (Get.isDialogOpen == true || _isLoginDialogScheduled) {
    return;
  }

  if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
    _showLoginRequiredDialogNow();
    return;
  }

  _isLoginDialogScheduled = true;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _isLoginDialogScheduled = false;
    if (Get.isDialogOpen == true) {
      return;
    }
    _showLoginRequiredDialogNow();
  });
}

void _showLoginRequiredDialogNow() {
  final context = Get.context;
  final theme = context != null ? Theme.of(context) : null;

  Get.defaultDialog(
    title: '',
    titlePadding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    radius: 22,
    contentPadding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 68,
          width: 68,
          decoration: BoxDecoration(
            color: LightThemeColors.primaryColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: LightThemeColors.primaryColor,
            size: 34,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Login Required',
          textAlign: TextAlign.center,
          style: theme?.textTheme.titleLarge?.copyWith(
                color: LightThemeColors.titleTextColor,
                fontWeight: FontWeight.w700,
              ) ??
              const TextStyle(
                color: LightThemeColors.titleTextColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please login to continue.',
          textAlign: TextAlign.center,
          style: theme?.textTheme.bodyMedium?.copyWith(
                color: LightThemeColors.subtitleTextColor,
                height: 1.35,
              ) ??
              const TextStyle(
                color: LightThemeColors.subtitleTextColor,
                fontSize: 14,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: LightThemeColors.bodyTextColor,
                  side: const BorderSide(color: LightThemeColors.borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightThemeColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.signIn);
                },
                child: Text(Strings.signIn.tr),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
