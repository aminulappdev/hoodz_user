class PaymentCard {
  final String brand;
  final String maskedNumber;
  final String expiry;

  const PaymentCard({
    required this.brand,
    required this.maskedNumber,
    required this.expiry,
  });
}