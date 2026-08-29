import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class SearchSectionHeader extends StatelessWidget {
  const SearchSectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.actionIcon,
    required this.onActionTap,
  });

  final String title;
  final String actionText;
  final IconData actionIcon;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18.sp(context),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF363636),
            ),
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Row(
            children: [
              Text(
                actionText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8C8C8C),
                ),
              ),
              SizedBox(width: 4.w(context)),
              Icon(
                actionIcon,
                size: 18,
                color: const Color(0xFF8C8C8C),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchChip extends StatelessWidget {
  const SearchChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

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
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(999.r(context)),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C6C6C),
          ),
        ),
      ),
    );
  }
}
