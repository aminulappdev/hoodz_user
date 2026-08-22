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

  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.onPressed,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50.h(context),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent),
          color: backgroundColor ?? LightThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(30.r(context)),
        ),
        child: Center(
          child: Text(
            text,
            style:
                textStyle ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontFamily: 'Geist',
                  fontSize: 16.sp(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
