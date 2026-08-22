enum DeliveryMethodType { card, wallet, cashOnDelivery }

class DeliveryMethodItem {
  final String title;
  final List<String> providers;
  final DeliveryMethodType type;

  const DeliveryMethodItem({
    required this.title,
    required this.providers,
    required this.type,
  });
}
