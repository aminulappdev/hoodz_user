import 'package:get/get.dart';

class CartController extends GetxController {
  final double deliveryCharge = 1.00;

  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[
    {
      'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      'name': 'Classic Black Blazer Premium Quality',
      'size': 'M',
      'color': 'Black',
      'price': 42.95,
      'quantity': 1,
    },
    {
      'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      'name': 'Classic Black Blazer Premium Quality',
      'size': 'M',
      'color': 'Black',
      'price': 42.95,
      'quantity': 1,
    },
    {
      'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      'name': 'Classic Black Blazer Premium Quality',
      'size': 'M',
      'color': 'Black',
      'price': 42.95,
      'quantity': 1,
    },
    {
      'image': 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      'name': 'Classic Black Blazer Premium Quality',
      'size': 'M',
      'color': 'Black',
      'price': 42.95,
      'quantity': 1,
    },
  ].obs;

  final List<Map<String, String>> recommendedItems = const [
    {
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
      'name': 'Classic Black Shirt',
      'category': 'Women',
      'rating': '4.5 (1k)',
      'price': '\$42',
    },
    {
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
      'name': 'Classic Black Shirt',
      'category': 'Women',
      'rating': '4.5 (1k)',
      'price': '\$42',
    },
  ];

  double get subTotal => cartItems.fold<double>(
    0,
    (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int),
  );

  double get totalCost => subTotal + deliveryCharge;

  String get itemLabel =>
      '${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'}';

  void increaseQuantity(int index) {
    final item = Map<String, dynamic>.from(cartItems[index]);
    item['quantity'] = (item['quantity'] as int) + 1;
    cartItems[index] = item;
  }

  void decreaseQuantity(int index) {
    final item = Map<String, dynamic>.from(cartItems[index]);
    final quantity = item['quantity'] as int;
    if (quantity <= 1) {
      return;
    }

    item['quantity'] = quantity - 1;
    cartItems[index] = item;
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }
}
