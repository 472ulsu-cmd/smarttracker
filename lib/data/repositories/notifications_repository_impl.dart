import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../models/notifications_response.dart' as api;
import '../models/user_request.dart' as api;

class NotificationsRepositoryImpl implements NotificationsRepository {
  NotificationsRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<NotificationItem>> fetchNotifications({int typeId = 2}) async {
    try {
      final response = await _dio.get<dynamic>('/notification/$typeId');
      final list = response.data is List ? response.data as List : [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => _toDomain(api.NotificationsResponseItem.fromJson(e)))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await _dio.put<dynamic>(
        '/notification/$id',
        data: {'status_id': 2},
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> markAllAsRead(Iterable<int> ids) async {
    // Параллельные запросы для каждого id.
    await Future.wait(ids.map((id) => markAsRead(id).catchError((_) {})));
  }

  @override
  Future<void> sendFcmToken(String token) async {
    try {
      await _dio.put<dynamic>(
        '/user/notification',
        data: api.UserNotificationRequest(token: token),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  NotificationItem _toDomain(api.NotificationsResponseItem n) {
    return NotificationItem(
      id: n.id ?? 0,
      message: n.message ?? '',
      datetime: n.datetime ?? '',
      isRead: (n.statusId ?? 1) == 2,
      orderId: n.orderId,
      routePhotoId: n.routePhotoId,
      routePhotoTypeId: n.routePhotoTypeId,
    );
  }

  Never _rethrowDio(DioException e) {
    final cause = e.error;
    if (cause is AppException) throw cause;
    throw const NetworkException();
  }
}
