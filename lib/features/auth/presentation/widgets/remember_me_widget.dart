import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
    required this.value,
    required this.onToggle,
    required this.onForgotPassword,
  });

  final bool value;
  final VoidCallback onToggle;
  final VoidCallback onForgotPassword;

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
                'Remember me',
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
            'Forgot Password?',
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
