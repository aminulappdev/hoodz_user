import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final RxString selectedSize = 'XS'.obs;
  final RxInt selectedColorIndex = 1.obs;

  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<Color> colors = const [
    Colors.black,
    Color(0xff233F93),
    Color(0xff7D8595),
    Color(0xffD7B88F),  
  ];

  final List<Map<String, String>> productList = [
    {
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      'name': 'Classic Black T-Shirt',
      'price': '\$45.00',
      'rating': '4.7',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
    },
    {
      'image': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246',
      'name': 'Slim Fit Blue Jeans',
      'price': '\$68.00',
      'rating': '4.6',
      'isFavorite': 'true',
      'imageUrl':
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246',
    },
    {
      'image': 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b',
      'name': 'White Sneakers for Men Shoes',
      'price': '\$89.00',
      'rating': '4.8',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1529139574466-a303027c1d8b',
    },
    {
      'image': 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
      'name': 'Beige Trench Coat',
      'price': '\$120.00',
      'rating': '4.9',
      'isFavorite': 'true',
      'imageUrl':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f',
    },
    {
      'image': 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c',
      'name': 'Brown Leather Jacket',
      'price': '\$149.00',
      'rating': '4.8',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c',
    },
    {
      'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
      'name': 'Red Hoodie',
      'price': '\$59.00',
      'rating': '4.5',
      'isFavorite': 'true',
      'imageUrl':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b',
    },
    
    {
      'image': 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2',
      'name': 'Running Sports Shoes',
      'price': '\$110.00',
      'rating': '4.9',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1460353581641-37baddab0fa2',
    },
  ];

  void onSizeSelected(String size) {
    selectedSize.value = size;
  }

  void onColorSelected(int index) {
    selectedColorIndex.value = index;
  }
}
