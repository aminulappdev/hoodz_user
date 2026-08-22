import 'package:flutter/material.dart';
import 'package:hoodz/app/theme/light_theme_colors.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class HaveAnAccount extends StatelessWidget {
  final String content;
  final String buttonTitle;
  final VoidCallback? onPressed;
  const HaveAnAccount({
    super.key,
    this.onPressed,
    required this.content,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Color(0xFF757575),
            fontFamily: 'Geist',
            fontSize: 14.sp(context),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 4.w(context)),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            buttonTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LightThemeColors.primaryColor,
              fontFamily: 'Geist',
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: LightThemeColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
