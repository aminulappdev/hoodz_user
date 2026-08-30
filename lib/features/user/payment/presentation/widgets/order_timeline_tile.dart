import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_successfull_controller.dart';

class OrderTimelineTile extends StatelessWidget {
  final String title;
  final String? timeLabel;
  final OrderTimelineState state;
  final bool showConnector;

  const OrderTimelineTile({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.state,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == OrderTimelineState.completed;

    return SizedBox(
      height: 44.h(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                            ? const Color(0xFF72E2A1)
                            : const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(999.r(context)),
                      ),
                    ),
                  ),
                Container(
                  width: 24.w(context),
                  height: 24.w(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? const Color(0xFF28C76F) : Colors.white,
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFF28C76F)
                          : const Color(0xFFE2E2E2),
                    ),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.access_time,
                    size: 14.sp(context),
                    color: isCompleted ? Colors.white : const Color(0xFFC6C6C6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 1.h(context)),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp(context),
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFF555555)
                      : const Color(0xFFC1C1C1),
                ),
              ),
            ),
          ),
          if (timeLabel != null && timeLabel!.trim().isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w(context),
                vertical: 4.h(context),
              ),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.transparent
                    : const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(999.r(context)),
              ),
              child: Text(
                timeLabel!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp(context),
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFF7A7A7A)
                      : const Color(0xFFC0C0C0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
