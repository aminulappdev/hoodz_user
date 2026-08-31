import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/features/user/payment/presentation/models/delivery_method_item.dart';

class DeliveryMethodController extends GetxController {
  final Rx<DeliveryMethodType> selectedMethodType = DeliveryMethodType.card.obs;

  final List<DeliveryMethodItem> methods = const [
    DeliveryMethodItem(
      title: Strings.debitCreditCard,
      providers: ['Visa', 'Master Card'],
      type: DeliveryMethodType.card,
    ),
    DeliveryMethodItem(
      title: Strings.smartWallets,
      providers: ['Apple Pay', 'Google Pay', 'PayPal'],
      type: DeliveryMethodType.wallet,
    ),
    DeliveryMethodItem(
      title: Strings.cashOnDelivery,
      providers: [Strings.payOnDelivery],
      type: DeliveryMethodType.cashOnDelivery,
    ),
  ];

  void selectMethod(DeliveryMethodType type) {
    selectedMethodType.value = type;
  }
}
