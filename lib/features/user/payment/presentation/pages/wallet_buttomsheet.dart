import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/services/others/payment_webview_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/core/utils/flutter_toast.dart';
import 'package:hoodz/core/widgets/custom_button.dart';
import 'package:hoodz/core/widgets/custom_text_field.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/payment_transaction_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_top_up_controller.dart';
import 'package:hoodz/features/user/payment/presentation/controllers/wallet_transaction_controller.dart';

class AddBalanceBottomSheetContent extends StatefulWidget {
  const AddBalanceBottomSheetContent({super.key});

  @override
  State<AddBalanceBottomSheetContent> createState() =>
      _AddBalanceBottomSheetContentState();
}

class _AddBalanceBottomSheetContentState
    extends State<AddBalanceBottomSheetContent> {
  late final WalletTopUpController _controller;
  final PaymentWebViewService _paymentWebViewService =
      const PaymentWebViewService();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<WalletTopUpController>();
    _controller.amountController.clear();
  }

  Future<void> _handlePayNow() async {
    final response = await _controller.addWalletMoney();
    if (!mounted || response == null) {
      return;
    }

    final paymentUrl = response.data?.paymentUrl;
    if (paymentUrl == null || paymentUrl.trim().isEmpty) {
      showAppToast(
        message: Strings.paymentUrlNotFound.tr,
        isError: true,
      );
      return;
    }

    final returnUrl = response.data?.returnUrl;
    Navigator.of(context).pop();

    await _paymentWebViewService.openCardPayment(
      paymentUrl: paymentUrl,
      returnUrl: returnUrl,
      onPaymentCompleted: () {
        Get.find<WalletTransactionController>().fetchWalletTransactions();
        Get.find<PaymentTransactionController>().fetchPaymentTransactions();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    Strings.addBalance.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2F2F2F),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
              SizedBox(height: 16.h(context)),
              Text(
                Strings.amount.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2F2F2F),
                ),
              ),
              SizedBox(height: 10.h(context)),
              CustomTextField(
                controller: _controller.amountController,
                borderRadius: 10,
                hintText: Strings.enterAmount.tr,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 10.h(context)),
              Text(
                Strings.quickAdd.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2F2F2F),
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 8) / 2;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [100, 250, 500, 1000]
                        .map(
                          (value) => SizedBox(
                            width: itemWidth,
                            child: InkWell(
                              onTap: () => setState(() {
                                _controller.setAmount(value);
                              }),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h(context),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F8F8),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFECECEC),
                                  ),
                                ),
                                child: Text(
                                  '+$value',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 14.sp(context),
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF2F2F2F),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              SizedBox(height: 16.h(context)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEDEDED)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.credit_card_rounded,
                        color: Color(0xFFFF6200),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.debitCreditCard.tr,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 14.sp(context),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF252525),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Strings.payViaPaymobGateway.tr,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 12.sp(context),
                                  color: const Color(0xFF98A2B3),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Color(0xFF4987FF),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your wallet balance will be updated instantly after successful payment.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: Color(0xFF4987FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomButton(
                  text: _controller.isLoading.value
                      ? Strings.pleaseWait.tr
                      : Strings.payNow.tr,
                  onPressed: _controller.isLoading.value ? null : _handlePayNow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
