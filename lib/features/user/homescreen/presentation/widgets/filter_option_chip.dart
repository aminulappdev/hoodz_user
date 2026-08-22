import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w(context),
          vertical: 8.h(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEDE3) : Colors.white,
          borderRadius: BorderRadius.circular(999.r(context)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD0B2)
                : const Color(0xFFE8E8E8),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: isSelected
                ? const Color(0xFFFF7A1A)
                : const Color(0xFF737373),
          ),
        ),
      ),
    );
  }
}
