
import 'package:crash_safe_image/crash_safe_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/policy_title.dart';
import 'package:hoodz/gen/assets.gen.dart';

class ProductPolicySection extends StatelessWidget {
  const ProductPolicySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductInfoTile(
          icon: CrashSafeImage(
            Assets.icons.truck.path,
            height: 24.h(context),
            width: 24.w(context),
            color: const Color(0xff4A4A4A),
          ),
          title: Strings.instantDeliveryAvailable.tr,
          subtitle: Strings.businessDays.tr,
        ),
        SizedBox(height: 20.h(context)),
        ProductInfoTile(
          icon: Icon(
            Icons.shield_outlined,
            color: const Color(0xff4A4A4A),
            size: 24.h(context),
          ),
          title: Strings.securePayment.tr,
          subtitle: Strings.secureTransactions.tr,
        ),
        SizedBox(height: 20.h(context)),
        ProductInfoTile(
          icon: Icon(
            Icons.refresh_rounded,
            color: const Color(0xff4A4A4A),
            size: 24.h(context),
          ),
          title: Strings.returnExchangePolicies.tr,
          subtitle: Strings.returnPolicy.tr,
        ),
      ],
    );
  }
}
