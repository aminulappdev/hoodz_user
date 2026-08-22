import '../datasources/orders_remote_data_source.dart';
import '../models/order_model.dart';

class OrdersRepository {
  OrdersRepository({OrdersRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? const OrdersRemoteDataSource();

  final OrdersRemoteDataSource _remoteDataSource;

  Future<List<OrderModel>> fetchOrders() {
    return _remoteDataSource.fetchOrders();
  }
}
