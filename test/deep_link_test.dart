import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/config/refresh_bus.dart';
import 'package:smarttracker/core/background/push_service.dart';

void main() {
  group('DeepLinkBus', () {
    test('request/consume: возвращает путь и очищает поле', () {
      final bus = DeepLinkBus();
      var fired = 0;
      bus.addListener(() => fired++);

      bus.request('/main/orders/123');

      expect(fired, 1);
      expect(bus.consume(), '/main/orders/123');
      // Повторный consume без нового request → null (не переоткроет экран).
      expect(bus.consume(), isNull);
    });

    test('consume без request возвращает null', () {
      final bus = DeepLinkBus();
      expect(bus.consume(), isNull);
    });
  });

  group('NotificationMessageParser', () {
    test('парсит order_id из data-payload (snake_case)', () {
      final message = RemoteMessage(data: {'order_id': '123', 'message': 'текст'});
      final parsed = NotificationMessageParser.parse(message);

      expect(parsed, isNotNull);
      expect(parsed!.orderId, 123);
      expect(parsed.body, 'текст');
    });

    test('парсит orderId из data-payload (camelCase — реальный формат FCM)', () {
      // Бэкенд FCM шлёт camelCase: {orderId, notificationId}.
      // REST /notification шлёт snake_case: {order_id}. Парсер берёт оба.
      final message = RemoteMessage(data: {'orderId': '72', 'notificationId': '64'});
      final parsed = NotificationMessageParser.parse(message);

      expect(parsed, isNotNull);
      expect(parsed!.orderId, 72);
    });

    test('возвращает null для пустого сообщения', () {
      final message = RemoteMessage(data: {});
      expect(NotificationMessageParser.parse(message), isNull);
    });

    test('orderId null, если order_id отсутствует — навигация не запустится', () {
      final message = RemoteMessage(data: {'message': 'без заказа'});
      final parsed = NotificationMessageParser.parse(message);

      expect(parsed, isNotNull);
      expect(parsed!.orderId, isNull);
    });
  });

  group('PushService.pathFor (выбор маршрута по тапу)', () {
    test('обычный пуш → карточка заявки', () {
      final n = const ParsedNotification(title: 't', body: 'b', orderId: 72);
      expect(PushService.pathFor(n), '/main/orders/72');
    });

    test('фото-пуш (есть routePhotoId) → вкладка фото заявки', () {
      const n = ParsedNotification(
        title: 't',
        body: 'Фото отклонено: бла',
        orderId: 72,
        routePhotoId: 5,
      );
      expect(PushService.pathFor(n), '/main/orders/72/photos');
    });

    test('фото-пуш без orderId → null (маршрут фото требует orderId)', () {
      const n = ParsedNotification(
        title: 't',
        body: 'Фото отклонено',
        routePhotoId: 5,
      );
      expect(PushService.pathFor(n), isNull);
    });

    test('пуш без orderId и без routePhotoId → null', () {
      const n = ParsedNotification(title: 't', body: 'b');
      expect(PushService.pathFor(n), isNull);
    });
  });
}
