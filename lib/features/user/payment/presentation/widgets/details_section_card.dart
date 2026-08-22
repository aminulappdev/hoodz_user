import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class DetailsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailsSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14.w(context),
        14.h(context),
        14.w(context),
        14.h(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18.sp(context),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4A4A4A),
            ),
          ),
          SizedBox(height: 12.h(context)),
          child,
        ],
      ),
    );
  }
}

class DetailsInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const DetailsInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9B9B9B),
              ),
            ),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp(context),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ),
        ],
      ),
    );

    if (!showDivider) {
      return row;
    }

    return Column(
      children: [
        row,
        const Divider(height: 1, color: Color(0xFFEAEAEA)),
      ],
    );
  }
}
