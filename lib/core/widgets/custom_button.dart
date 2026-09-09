import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? prefixIcon;

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.onPressed,
    this.enabled = true,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor = enabled
        ? (backgroundColor ?? LightThemeColors.primaryColor)
        : const Color(0xFFE5E7EB);
    final Color effectiveBorderColor = enabled
        ? (borderColor ?? Colors.transparent)
        : const Color(0xFFD1D5DB);
    final Color effectiveTextColor = enabled
        ? (textStyle?.color ?? Colors.white)
        : const Color(0xFF9CA3AF);

    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 50.h(context),
          decoration: BoxDecoration(
            border: Border.all(color: effectiveBorderColor),
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(30.r(context)),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, color: effectiveTextColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style:
                      textStyle?.copyWith(color: effectiveTextColor) ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: effectiveTextColor,
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
    );
  }
}
