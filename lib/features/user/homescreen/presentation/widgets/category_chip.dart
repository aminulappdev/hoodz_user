
import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({super.key, 
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
          horizontal: 18.w(context),
          vertical: 9.h(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFAF6) : Colors.white,
          borderRadius: BorderRadius.circular(999.r(context)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD2B0)
                : const Color(0xFFE8E8E8),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6A6A6A),
          ),
        ),
      ),
    );
  }
}
