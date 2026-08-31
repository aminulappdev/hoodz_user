import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ReviewDropdown extends StatelessWidget {
  const ReviewDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r(context)),
        border: Border.all(color: const Color(0xFFE3E3E3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp(context),
            color: const Color(0xFF2C2C2C),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            final label = item == Strings.latest
                ? Strings.latest.tr
                : item == Strings.highest
                    ? Strings.highest.tr
                    : item == Strings.lowest
                        ? Strings.lowest.tr
                        : item;
            return DropdownMenuItem<String>(value: item, child: Text(label));
          }).toList(),
        ),
      ),
    );
  }
}
