import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/shop/data/models/shop_details_model.dart';

class ShopAvailabilityCard extends StatelessWidget {
  const ShopAvailabilityCard({super.key, this.policies});

  final Policies? policies;

  @override
  Widget build(BuildContext context) {
    final openingTime = policies?.openingTime?.trim() ?? '';
    final closingTime = policies?.closingTime?.trim() ?? '';
    final availabilityValue = _availabilityValue(openingTime, closingTime);
    final isOpenNow = _isOpenNow(openingTime, closingTime);
    final statusColor = isOpenNow
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final statusText = isOpenNow ? 'Open now' : 'Closed';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r(context)),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 20.h(context),
                    color: const Color(0xff1D2B53),
                  ),
                  SizedBox(width: 8.w(context)),
                  Text(
                    'Availability',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff222222),
                    ),
                  ),
                ],
              ),
              Text(
                statusText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h(context)),
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          SizedBox(height: 14.h(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Opening Time',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  color: const Color(0xff777777),
                ),
              ),
              Text(
                availabilityValue,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _availabilityValue(String openingTime, String closingTime) {
    if (openingTime.isEmpty && closingTime.isEmpty) {
      return '-';
    }

    if (openingTime.isEmpty) {
      return closingTime;
    }

    if (closingTime.isEmpty) {
      return openingTime;
    }

    return '$openingTime - $closingTime';
  }

  bool _isOpenNow(String openingTime, String closingTime) {
    final open = _parseTimeOfDay(openingTime);
    final close = _parseTimeOfDay(closingTime);

    if (open == null || close == null) {
      return false;
    }

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = open.hour * 60 + open.minute;
    final closeMinutes = close.hour * 60 + close.minute;

    if (openMinutes == closeMinutes) {
      return false;
    }

    if (openMinutes < closeMinutes) {
      return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
    }

    return nowMinutes >= openMinutes || nowMinutes <= closeMinutes;
  }

  TimeOfDay? _parseTimeOfDay(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) {
      return null;
    }

    final regex = RegExp(r'^(\d{1,2})(?::(\d{1,2}))?\s*([AP]M)?$');
    final match = regex.firstMatch(normalized);
    if (match == null) {
      return null;
    }

    var hour = int.tryParse(match.group(1) ?? '');
    final minute = int.tryParse(match.group(2) ?? '') ?? 0;
    final meridiem = match.group(3);

    if (hour == null) {
      return null;
    }

    if (meridiem == 'AM') {
      if (hour == 12) {
        hour = 0;
      }
    } else if (meridiem == 'PM') {
      if (hour != 12) {
        hour += 12;
      }
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
