import 'package:get/get.dart';
import 'package:hoodz/features/user/payment/presentation/models/delivery_method_item.dart';

class DeliveryMethodController extends GetxController {
  final Rx<DeliveryMethodType> selectedMethodType = DeliveryMethodType.card.obs;

  final List<DeliveryMethodItem> methods = const [
    DeliveryMethodItem(
      title: 'Debit/Credit card',
      providers: ['Visa', 'Master Card'],
      type: DeliveryMethodType.card,
    ),
    DeliveryMethodItem(
      title: 'Smart Wallets',
      providers: ['Apple Pay', 'Google Pay', 'PayPal'],
      type: DeliveryMethodType.wallet,
    ),
    DeliveryMethodItem(
      title: 'Cash on Delivery',
      providers: ['Pay on delivery'],
      type: DeliveryMethodType.cashOnDelivery,
    ),
  ];

  void selectMethod(DeliveryMethodType type) {
    selectedMethodType.value = type;
  }
}
