import 'package:get/get.dart';
import 'package:hoodz/app/translator/strings_enum.dart';
import 'package:hoodz/core/constants/app_strings.dart';

class OrderController extends GetxController {
  final RxInt selectedStatusIndex = 0.obs;

  // 👇 তোমার কোড, অপরিবর্তিত রাখা হলো
  final List<String> orderStatuses = [
    '${Strings.active.tr} (2)',
    '${Strings.completed.tr} (3)',
    '${Strings.cancelled.tr} (1)',
  ];

  /// Actual order data — এটা যোগ করা হলো যাতে OrderScreen-এ
  /// ListView.builder ব্যবহার করা যায়, if/else copy-paste না করে।
  final List<OrderModel> allOrders = [
    OrderModel(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Classic T-Shirt',
      date: 'Today, 2:00 PM',
      orderID: '#HZ-1201',
      price: '1202',
      item: 3,
      type: 'processing',
    ),
    OrderModel(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Classic Black Blazer',
      date: 'Today, 2:30 PM',
      orderID: '#HZ-1202',
      price: '656',
      item: 3,
      type: 'processing',
    ),
    OrderModel(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Soft Knit Cardigan',
      date: 'July 13, 2026',
      orderID: '#HZ-1194',
      price: '840',
      item: 2,
      type: 'completed',
    ),
    OrderModel(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Running Sports Shoes',
      date: 'July 10, 2026',
      orderID: '#HZ-1188',
      price: '1100',
      item: 1,
      type: 'completed',
    ),
    OrderModel(
      imageUrl: AppStrings.demoImageUrl,
      name: 'Office Shoulder Bag',
      date: 'July 8, 2026',
      orderID: '#HZ-1179',
      price: '740',
      item: 1,
      type: 'cancelled',
    ),
  ];

  /// selectedStatusIndex (0/1/2) থেকে সঠিক orders ফিল্টার করে দেয়।
  /// index 0 = Active -> type == 'processing'
  /// index 1 = Completed -> type == 'completed'
  /// index 2 = Cancelled -> type == 'cancelled'
  List<OrderModel> get filteredOrders {
    switch (selectedStatusIndex.value) {
      case 0:
        return allOrders.where((o) => o.type == 'processing').toList();
      case 1:
        return allOrders.where((o) => o.type == 'completed').toList();
      default:
        return allOrders.where((o) => o.type == 'cancelled').toList();
    }
  }

  void changeStatus(int index) {
    selectedStatusIndex.value = index;
  }
}

class OrderModel {
  final String imageUrl;
  final String name;
  final String date;
  final String orderID;
  final String price;
  final int item;

  /// Must match OrderCard's expected values:
  /// 'processing' | 'completed' | 'cancelled'
  final String type;

  const OrderModel({
    required this.imageUrl,
    required this.name,
    required this.date,
    required this.orderID,
    required this.price,
    required this.item,
    required this.type,
  });
}
