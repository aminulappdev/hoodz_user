import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/models/payment_method_item.dart';

class AddPaymentController extends GetxController {
  final Rx<PaymentMethodType> selectedMethodType = PaymentMethodType.stripe.obs;
  final RxBool saveCardForFuture = false.obs;

  void selectMethod(PaymentMethodType type) {
    selectedMethodType.value = type;
  }

  void toggleSaveCard(bool? value) {
    saveCardForFuture.value = value ?? false;
  }
}
