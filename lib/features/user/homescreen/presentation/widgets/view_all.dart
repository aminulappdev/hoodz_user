import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class ViewAllList extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  const ViewAllList({super.key, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w800,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            Strings.viewAll.tr,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
