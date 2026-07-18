import 'package:dio/dio.dart';

import '../../domain/models/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../mappers/order_mapper.dart';
import '../models/orders_response.dart' as api;
import '../services/dio_error.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async {
    final items = await _fetchList('/orders');
    return items;
  }

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async {
    final items = await _fetchList('/orders/history');
    return items;
  }

  Future<List<OrderListItem>> _fetchList(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      final list = response.data is List ? response.data as List : [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => OrderMapper.toItem(api.OrdersResponseItem.fromJson(e)))
          .toList(growable: false);
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async {
    try {
      final response = await _dio.get<dynamic>('/orders/$orderId/main');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      return OrderMapper.toDetail(api.OrdersResponse.fromJson(data));
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }

  @override
  Future<void> changeStatus(int orderId, int statusId) async {
    try {
      await _dio.post<dynamic>('/orders/$orderId/status/$statusId');
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }
}
