import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/pages/payment_webview_screen.dart';

class PaymentWebViewService {
  const PaymentWebViewService();

  Future<void> openCardPayment({
    required String paymentUrl,
    String? returnUrl,
    VoidCallback? onPaymentCompleted,
  }) async {
    await Get.to(
      () => PaymentWebViewScreen(
        paymentUrl: paymentUrl,
        returnUrl: returnUrl,
        onPaymentCompleted: onPaymentCompleted,
      ),
    );
  }
}
