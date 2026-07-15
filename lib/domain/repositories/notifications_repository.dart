import '../models/notification_item.dart';

/// Контракт репозитория уведомлений.
abstract class NotificationsRepository {
  /// Список уведомлений (`GET /notification/{type_id}`).
  Future<List<NotificationItem>> fetchNotifications({int typeId = 2});

  /// Отметить прочитанным (`PUT /notification/{id}`, status_id: 2).
  Future<void> markAsRead(int id);

  /// Отметить прочитанными несколько (параллельные PUT).
  Future<void> markAllAsRead(Iterable<int> ids);

  /// Отправить FCM-токен (`PUT /user/notification`).
  Future<void> sendFcmToken(String token);
}
