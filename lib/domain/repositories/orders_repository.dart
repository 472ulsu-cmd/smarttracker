import '../models/order.dart';

/// Контракт репозитория заявок.
abstract class OrdersRepository {
  /// Список активных заявок (`GET /orders`).
  Future<List<OrderListItem>> fetchActiveOrders();

  /// Архив заявок (`GET /orders/history`).
  Future<List<OrderListItem>> fetchHistoryOrders();

  /// Детали заявки (`GET /orders/{id}/main`).
  Future<OrderDetail> fetchOrderDetail(int orderId);

  /// Смена статуса (`POST /orders/{id}/status/{statusId}`).
  Future<void> changeStatus(int orderId, int statusId);
}
