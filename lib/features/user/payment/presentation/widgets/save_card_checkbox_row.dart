import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class SaveCardCheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const SaveCardCheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20.w(context),
          height: 20.w(context),
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            side: const BorderSide(color: Color(0xFFCFCFCF)),
            activeColor: const Color(0xFFFF6B00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r(context)),
            ),
          ),
        ),
        SizedBox(width: 8.w(context)),
        Expanded(
          child: Text(
            'Save card data for future payments',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8B8B8B),
            ),
          ),
        ),
      ],
    );
  }
}
