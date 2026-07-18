import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config/refresh_bus.dart';
import '../../config/service_locator.dart';
import '../../data/services/local_photo_store.dart';
import '../../data/services/settings_service.dart';
import '../../domain/models/order_photo.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../ui/features/notifications/view_models/unread_badge_view_model.dart';

/// Парсер data-only FCM-сообщений в структуру {title, body, order_id,
/// route_photo_id, route_photo_type_id}.
class NotificationMessageParser {
  NotificationMessageParser._();

  /// Возвращает ParsedNotification или null, если данных недостаточно.
  static ParsedNotification? parse(RemoteMessage message) {
    final data = message.data;
    if (data.isEmpty && message.notification == null) return null;

    final title = message.notification?.title ??
        data['title'] as String? ??
        'Уведомление';
    final body = message.notification?.body ?? data['message'] as String? ?? '';
    final orderId = int.tryParse('${data['order_id'] ?? ''}');
    final routePhotoId = int.tryParse('${data['route_photo_id'] ?? ''}');
    final routePhotoTypeId = int.tryParse('${data['route_photo_type_id'] ?? ''}');

    return ParsedNotification(
      title: title,
      body: body,
      orderId: orderId,
      routePhotoId: routePhotoId,
      routePhotoTypeId: routePhotoTypeId,
    );
  }
}

class ParsedNotification {
  const ParsedNotification({
    required this.title,
    required this.body,
    this.orderId,
    this.routePhotoId,
    this.routePhotoTypeId,
  });
  final String title;
  final String body;
  final int? orderId;
  final int? routePhotoId;
  final int? routePhotoTypeId;
}

/// Парсер решения по фото из текста push-уведомления.
class PhotoDecisionParser {
  static OrderPhotoStatus? parse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('одобрен')) return OrderPhotoStatus.approved;
    if (lower.contains('отклонен')) return OrderPhotoStatus.rejected;
    return null;
  }

  static String extractReason(String message) {
    final idx = message.indexOf(':');
    if (idx < 0) return '';
    return message.substring(idx + 1).trim();
  }
}

/// Сервис push-уведомлений: FCM + локальные уведомления.
class PushService {
  PushService(this._notificationsRepo, this._settings);

  final NotificationsRepository _notificationsRepo;
  final SettingsService _settings;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'smarttracker_notifications';
  static const _channelName = 'Уведомления';

  StreamSubscription<RemoteMessage>? _onMessageSub;

  /// Инициализация. Возвращает FCM-токен (если получен) или null.
  Future<String?> init() async {
    // Локальные уведомления.
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // Канал для Android (для foreground-уведомлений).
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          importance: Importance.high,
        ));

    // FCM: запрос разрешения, получение токена.
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await _sendToken(token);
    }
    FirebaseMessaging.instance.onTokenRefresh.listen(_sendToken);

    // Foreground-сообщения → локальное уведомление (если push включён).
    _onMessageSub = FirebaseMessaging.onMessage.listen(_handleForeground);

    return token;
  }

  void dispose() {
    _onMessageSub?.cancel();
  }

  Future<void> _sendToken(String token) async {
    try {
      await _notificationsRepo.sendFcmToken(token);
    } catch (_) {
      // Токен отправим повторно при следующей возможности.
    }
  }

  void _handleForeground(RemoteMessage message) {
    final parsed = NotificationMessageParser.parse(message);
    // Триггерим обновление списков уведомлений и заявок при новом сообщении
    // (независимо от того, показано ли локальное уведомление).
    _refresh();
    if (parsed?.routePhotoId != null) {
      final decision = PhotoDecisionParser.parse(parsed!.body);
      if (decision == OrderPhotoStatus.rejected) {
        getIt<LocalPhotoStore>().saveRejectionReason(
          parsed.routePhotoId!,
          PhotoDecisionParser.extractReason(parsed.body),
        );
      }
    }
    if (!_settings.pushEnabled) return;
    if (parsed == null) return;
    _showLocal(parsed);
  }

  /// Триггер обновления списков уведомлений, заявок и бейджа.
  void _refresh() {
    try {
      getIt<NotificationsRefreshBus>().notifyChanged();
      getIt<OrdersRefreshBus>().notifyChanged();
      getIt<UnreadBadgeViewModel>().refresh();
    } catch (_) {
      // DI может быть ещё не готов — игнорируем.
    }
  }

  Future<void> _showLocal(ParsedNotification n) async {
    await _local.show(
      id: n.orderId ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: n.title,
      body: n.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
