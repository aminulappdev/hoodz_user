import '../models/order_model.dart';

class OrdersRemoteDataSource {
  const OrdersRemoteDataSource();

  Future<List<OrderModel>> fetchOrders() async {
    return const [
      OrderModel(id: 'HZ-1201', status: 'Processing', total: 1250),
      OrderModel(id: 'HZ-1202', status: 'Delivered', total: 860),
    ];
  }
}
