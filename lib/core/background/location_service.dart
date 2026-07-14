import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/services/city_lookup.dart';
import '../../data/services/pending_action_store.dart';
import '../../domain/models/geo_point.dart';
import '../../domain/models/pending_action.dart';

/// Запуск/остановка foreground-сервиса геолокации.
///
/// Каждый цикл получает текущую позицию и кладёт её в очередь
/// `pending_actions` для последующей отправки фоновым SyncService.
///
/// Требуется разрешение `LocationPermission.always`.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  static const _notificationChannelId = 'smarttracker_location';
  static const _notificationTitle = 'Умный Водитель';

  /// Интервал сбора координат по умолчанию (60 секунд, из SyncConfig).
  int intervalMs = 60000;

  /// Запросить разрешение геолокации «Всегда».
  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always;
  }

  /// Инициализация конфигурации foreground-задачи.
  void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _notificationChannelId,
        channelName: _notificationTitle,
        channelDescription: 'Передача геопозиции диспетчеру',
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(intervalMs),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  /// Старт foreground-сервиса.
  ///
  /// Разрешение геолокации должно быть уже получено на уровне приложения
  /// (через LocationPermissionViewModel). Здесь только запускаем сервис.
  Future<void> start({int? intervalMs}) async {
    if (intervalMs != null) this.intervalMs = intervalMs;
    init();
    FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
    await FlutterForegroundTask.startService(
      notificationTitle: _notificationTitle,
      notificationText: 'Передача геопозиции…',
    );
  }

  /// Остановить foreground-сервис.
  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}

/// Обработчик фоновой задачи геолокации.
///
/// Периодически (onRepeatEvent) получает позицию и складывает её
/// в локальную очередь [PendingActionStore] для последующей отправки.
@pragma('vm:entry-point')
class LocationTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await _collect();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _collect();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Нечего освобождать.
  }

  Future<void> _collect() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 15),
      );
      // Ближайший город определяется офлайн по встроенной БД.
      final city = await CityLookup.instance
          .resolveName(position.latitude, position.longitude);
      final point = GeoPoint(
        lat: position.latitude,
        lng: position.longitude,
        datetime: DateTime.now(),
        nearestCity: city,
      );
      await PendingActionStore.instance.enqueue(PendingAction(
        type: PendingActionType.coordinates,
        payload: point.toJson(),
        createdAt: DateTime.now(),
      ));
    } catch (_) {
      // Тихо игнорируем ошибки отдельного цикла.
    }
  }
}
