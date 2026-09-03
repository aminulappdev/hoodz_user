import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/gen/assets.gen.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool Function()? canShowDialog;
  final VoidCallback? onBlocked;
  final String buttonText;
  final String dialogTitle;
  final String dialogMessage;
  final String cancelText;
  final String confirmText;

  const LogoutButton({
    super.key,
    this.onTap,
    this.canShowDialog,
    this.onBlocked,
    this.buttonText = '',
    this.dialogTitle = '',
    this.dialogMessage = '',
    this.cancelText = '',
    this.confirmText = '',
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w(context)),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30.w(context),
              30.h(context),
              30.w(context),
              18.h(context),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r(context)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CrashSafeImage(
                  Assets.icons.logOut01.path,
                  height: 60.h(context),
                ),
                SizedBox(height: 20.h(context)),
                Text(
                  dialogTitle.isNotEmpty ? dialogTitle : Strings.logoutConfirmTitle.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 20.sp(context),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: 10.h(context)),
                Text(
                  dialogMessage.isNotEmpty
                      ? dialogMessage
                      : Strings.logoutConfirmMessage.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp(context),
                    color: const Color(0xFF8B8B8B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 22.h(context)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h(context),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r(context)),
                            border: Border.all(color: const Color(0xFFEDEDED)),
                          ),
                          child: Center(
                            child: Text(
                              cancelText.isNotEmpty ? cancelText : Strings.cancel.tr,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 14.sp(context),
                                    color: const Color(0xFF3D3D3D),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w(context)),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h(context),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEF0),
                            borderRadius: BorderRadius.circular(14.r(context)),
                          ),
                          child: Center(
                            child: Text(
                              confirmText.isNotEmpty
                                  ? confirmText
                                  : Strings.logout.tr,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 14.sp(context),
                                    color: const Color(0xFFFF5B6E),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (canShowDialog?.call() == false) {
          onBlocked?.call();
          return;
        }

        _showLogoutDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h(context)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
          border: Border.all(color: const Color(0xffF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: LightThemeColors.primaryColor,
              size: 18.h(context),
            ),
            SizedBox(width: 8.w(context)),
            Text(
              buttonText.isNotEmpty ? buttonText : Strings.logout.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                color: LightThemeColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
