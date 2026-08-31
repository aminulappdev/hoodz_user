import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class AddVoucherRow extends StatelessWidget {
  final VoidCallback? onTap;
  const AddVoucherRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          Strings.saveOnYourOrder.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w700,
            color: const Color(0xff434343),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            Strings.addVoucher.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              color: const Color(0xff666666),
            ),
          ),
        ),
      ],
    );
  }
}
