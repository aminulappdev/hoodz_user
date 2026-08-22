class PaymentMethod {
  final String type;
  final String maskedNumber;
  final String expiry;

  const PaymentMethod({
    required this.type,
    required this.maskedNumber,
    required this.expiry,
  });
}

class SummaryItem {
  final String label;
  final String value; 

  const SummaryItem(this.label, this.value);
}