import 'package:get/get.dart';
import 'package:hoodz/core/constants/app_strings.dart';

class ShopController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final RxString shopName = 'Urban Style'.obs;
  final RxString distance = '1.2 km'.obs;
  final RxString deliveryTime = '20-25 min'.obs;
  final RxDouble rating = 4.5.obs;
  final RxString likes = '1k'.obs;
  final RxString followers = '5k'.obs;
  final RxString establishedYear = '2015'.obs;
  final RxString location = 'New York, USA'.obs;
  final RxString ratingSummary = '4.6 (1.8k reviews)'.obs;
  final RxString description =
      'Premium fashion brand offering contemporary styles for the modern individual. Established in 2015, we bring you curated collections that blend comfort with elegance.'
          .obs;

  final List<String> categories = const [
    'Men',
    'Women',
    'Shoes',
    'Bags',
    'Sportswear',
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
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      'name': 'Office Shoulder Bag',
      'price': '\$74.00',
      'rating': '4.4',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
    },
    {
      'image': 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b',
      'name': 'Casual Summer Dress',
      'price': '\$64.00',
      'rating': '4.7',
      'isFavorite': 'true',
      'imageUrl':
          'https://images.unsplash.com/photo-1523381210434-271e8be1f52b',
    },
    {
      'image': 'https://images.unsplash.com/photo-1496747611176-843222e1e57c',
      'name': 'Soft Knit Cardigan',
      'price': '\$52.00',
      'rating': '4.6',
      'isFavorite': 'false',
      'imageUrl':
          'https://images.unsplash.com/photo-1496747611176-843222e1e57c',
    },
    {
      'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
      'name': 'Elegant Wrist Watch',
      'price': '\$95.00',
      'rating': '4.8',
      'isFavorite': 'true',
      'imageUrl':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
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
  
  final List<Map<String, String>> categoryList = [
    {'image': AppStrings.demoImageUrl, 'name': 'Men'},
    {'image': AppStrings.demoImageUrl, 'name': 'Women'},
    {'image': AppStrings.demoImageUrl, 'name': 'Shoes'},
    {'image': AppStrings.demoImageUrl, 'name': 'Bags'},
    {'image': AppStrings.demoImageUrl, 'name': 'Accessories'},
  ];

  final List<String> storePolicies = const [
    'Free delivery on orders over \$50',
    '30-day return policy',
    'Secure payment options',
    'Customer support available 24/7',
  ];

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
