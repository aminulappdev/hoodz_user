import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/payment/presentation/pages/voucher_screen.dart';
import 'package:hoodz/gen/assets.gen.dart';

class VoucherCardHomeScreen extends StatelessWidget {
  const VoucherCardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(VouchersScreen());
      },
      child: Container(
        height: 56.h(context),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFF75908).withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10.r(context)),
          border: Border.all(color: const Color(0xFFFFE7DA), width: 0.5),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w(context)),
          child: Row(
            children: [
              CrashSafeImage(
                Assets.icons.voucher.keyName,
                height: 32.h(context),
              ),
              SizedBox(width: 10.w(context)),
              Text(
                '2 ${Strings.vouchers.tr}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
