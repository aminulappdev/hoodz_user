import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
    required this.value,
    required this.onToggle,
    required this.onForgotPassword,
    this.rememberMeText = '',
    this.forgotPasswordText = '',
  });

  final bool value;
  final VoidCallback onToggle;
  final VoidCallback onForgotPassword;
  final String rememberMeText;
  final String forgotPasswordText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Icon(
                value ? Icons.check_box : Icons.check_box_outline_blank,
                color: const Color(0xFF757575),
                size: 18.sp(context),
              ),
              SizedBox(width: 4.w(context)),
              Text(
                rememberMeText.isNotEmpty ? rememberMeText : Strings.rememberMe.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF757575),
                  fontFamily: 'Geist',
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onForgotPassword,
          child: Text(
            forgotPasswordText.isNotEmpty
                ? forgotPasswordText
                : Strings.forgotPassword.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF757575),
              fontFamily: 'Geist',
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
