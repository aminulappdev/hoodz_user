import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/circle_icon.dart';

class SearchHeaderRow extends StatelessWidget {
  final String leadingIconPath;
  final String trailingIconPath;
  final String hintText;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapTrailing;
  final VoidCallback? onTapSearch;

  const SearchHeaderRow({
    super.key,
    required this.leadingIconPath,
    required this.trailingIconPath,
    required this.hintText,
    this.onTapLeading,
    this.onTapTrailing,
    this.onTapSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIcon(
          iconPath: leadingIconPath,
          size: 18,
          iconSize: 12,
          onTap: onTapLeading,
        ),
        SizedBox(width: 12.w(context)),
        Expanded(
          child: GestureDetector(
            onTap: onTapSearch,
            child: Container(
              height: 42.h(context),
              padding: EdgeInsets.symmetric(horizontal: 14.w(context)),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(999.r(context)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF8C8C8C),
                    size: 22.sp(context),
                  ),
                  SizedBox(width: 8.w(context)),
                  Text(
                    hintText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFA2A2A2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w(context)),
        CircleIcon(
          iconPath: trailingIconPath,
          size: 18,
          iconSize: 20,
          onTap: onTapTrailing,
        ),
      ],
    );
  }
}
