import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_method_item.dart';
import 'package:hoodz/gen/assets.gen.dart';

class PaymentMethodController extends GetxController {
  final Rx<PaymentMethodType> selectedMethodType = PaymentMethodType.paypal.obs;

  final List<PaymentMethodItem> methods = [
    PaymentMethodItem(
      iconData: Assets.icons.payPal.path,
      maskedNumber: '2350 **** **** **45',
      expiryLabel: 'Expire 03/30',
      type: PaymentMethodType.paypal,
    ),
    PaymentMethodItem(
      iconData: Assets.icons.stripe.path,
      maskedNumber: '2350 **** **** **45',
      expiryLabel: 'Expire 03/30',
      type: PaymentMethodType.stripe,
    ),
  ];

  void selectMethod(PaymentMethodType type) {
    selectedMethodType.value = type;
  }
}
