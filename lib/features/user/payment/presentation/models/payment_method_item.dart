enum PaymentMethodType { paypal, stripe }

class PaymentMethodItem {
  final String iconData;
  final String maskedNumber;
  final String expiryLabel;
  final PaymentMethodType type;

  const PaymentMethodItem({
    required this.iconData,
    required this.maskedNumber,
    required this.expiryLabel,
    required this.type,
  });
}
