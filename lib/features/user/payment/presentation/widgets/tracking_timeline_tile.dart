import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_details_controller.dart';

class TrackingTimelineTile extends StatelessWidget {
  final String title;
  final String trailingText;
  final TrackingTimelineState state;
  final bool showConnector;

  const TrackingTimelineTile({
    super.key,
    required this.title,
    required this.trailingText,
    required this.state,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == TrackingTimelineState.completed;
    final isActive = state == TrackingTimelineState.active;
    final isPending = state == TrackingTimelineState.pending;

    return SizedBox(
      height: 44.h(context),
      child: Row(
        children: [
          SizedBox(
            width: 28.w(context),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                if (showConnector)
                  Positioned(
                    top: 24.h(context),
                    bottom: 0,
                    child: Container(
                      width: 2.w(context),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFF56D685)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(999.r(context)),
                      ),
                    ),
                  ),
                Container(
                  width: 24.w(context),
                  height: 24.w(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isActive
                        ? (isActive
                              ? const Color(0xFFFF6B00)
                              : const Color(0xFF28C76F))
                        : Colors.white,
                    border: Border.all(
                      color: isCompleted || isActive
                          ? Colors.transparent
                          : const Color(0xFFE2E2E2),
                    ),
                  ),
                  child: Icon(
                    _resolveIcon(),
                    size: 14.sp(context),
                    color: isPending
                        ? const Color(0xFFC8C8C8)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp(context),
                fontWeight: FontWeight.w600,
                color: isActive
                    ? const Color(0xFFFF6B00)
                    : isPending
                    ? const Color(0xFFC1C1C1)
                    : const Color(0xFF555555),
              ),
            ),
          ),
          Text(
            trailingText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12.sp(context),
              fontWeight: FontWeight.w600,
              color: isPending
                  ? const Color(0xFFAFAFAF)
                  : const Color(0xFF6F6F6F),
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon() {
    if (state == TrackingTimelineState.completed) {
      return Icons.check_rounded;
    }
    if (state == TrackingTimelineState.active) {
      return Icons.inventory_2_outlined;
    }
    return Icons.inventory_2_outlined;
  }
}
