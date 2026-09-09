import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class RiderNotificationItemCard extends StatelessWidget {
  const RiderNotificationItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = true,
    this.highlighted = false,
    this.showDelete = false,
  });

  final String title;
  final String description;
  final String time;
  final bool isRead;
  final bool highlighted;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    final titleWeight = isRead ? FontWeight.w600 : FontWeight.w800;
    final descriptionWeight = isRead ? FontWeight.w400 : FontWeight.w700;

    final card = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w(context),
        vertical: 12.h(context),
      ),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFFFF1E9) : Colors.white,
        borderRadius: BorderRadius.circular(2.r(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36.h(context),
            width: 36.w(context),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              color: const Color(0xFF5A5A5A),
              size: 17.sp(context),
            ),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF3B3B3B),
                          fontSize: 14.sp(context),
                          fontWeight: titleWeight,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w(context)),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8A8A8A),
                        fontSize: 12.sp(context),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h(context)),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF707070),
                    fontSize: 12.sp(context),
                    fontWeight: descriptionWeight,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!showDelete) {
      return card;
    }

    return Slidable(
      key: ValueKey('$title-$time'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: const Color(0xFFC90016),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(2.r(context)),
              bottomRight: Radius.circular(2.r(context)),
            ),
          ),
        ],
      ),
      child: card,
    );
  }
}
