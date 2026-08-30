import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class TrackingSummaryCard extends StatelessWidget {
  const TrackingSummaryCard({
    super.key,
    this.distanceText = '2.5 km',
  });

  final String distanceText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: EdgeInsets.symmetric(
        horizontal: 14.w(context), 
        vertical: 12.h(context),
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
      child: Row(
        children: [
          Expanded( 
            child: _InfoBlock(
              icon: Icons.access_time_filled_rounded,
              iconBg: const Color(0xFFD8F8E3),
              iconColor: const Color(0xFF41C96E),
              label: 'Estimated Arrival',
              value: '20 min',
            ),
          ),
          Container(
            width: 1,
            height: 34.h(context),
            color: const Color(0xFFEAEAEA),
          ),
          Expanded(
            child: _InfoBlock(
              alignEnd: true,
              label: 'Distance',
              value: distanceText,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData? icon;
  final Color? iconBg;
  final Color? iconColor;
  final String label;
  final String value;
  final bool alignEnd;

  const _InfoBlock({
    this.icon,
    this.iconBg,
    this.iconColor,
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Container(
                width: 22.w(context),
                height: 22.w(context),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 13.sp(context), color: iconColor),
              ),
              SizedBox(width: 8.w(context)),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp(context),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9A9A9A),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h(context)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 24.sp(context),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF3E3E3E),
          ),
        ),
      ],
    );
  }
}
