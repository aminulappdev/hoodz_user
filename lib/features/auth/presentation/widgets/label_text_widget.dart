
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Color(0xFF757575),
        fontFamily: 'Geist',
        fontSize: 16.sp(context), 
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
