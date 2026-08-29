import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/widgets/custom_appbar.dart';
import 'package:hoodz/features/user/payment/presentation/widgets/voucher_card_design.dart';
import 'package:hoodz/features/user/product/presentation/controller/all_vouchers_controller.dart';

class AllVouchersScreen extends GetView<AllVouchersController> {
  const AllVouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    controller.initialize(routeArguments);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomAppBar(label: controller.title.value),
      body: SafeArea(
        child: Obx(
          () => controller.vouchers.isEmpty
              ? Center(
                  child: Text(
                    'No vouchers available',
                    style: TextStyle(
                      fontSize: 14.sp(context),
                      color: const Color(0xFF6B6B6B),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    12.w(context),
                    8.h(context),
                    12.w(context),
                    20.h(context),
                  ),
                  itemCount: controller.vouchers.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 14.h(context)),
                  itemBuilder: (context, index) {
                    return VoucherCardDesign(
                      voucher: controller.vouchers[index].voucher,
                      isUsed: controller.vouchers[index].isUsed,
                      usedAtText: controller.vouchers[index].usedAtText,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
