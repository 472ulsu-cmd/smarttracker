import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/app_config.dart';
import '../../config/service_locator.dart';
import '../../data/services/city_lookup.dart';
import '../../data/services/pending_action_store.dart';
import '../../domain/models/geo_point.dart';
import '../../domain/models/pending_action.dart';
import '../../domain/repositories/sync_repository.dart';
import 'coordinate_batching.dart';

/// Запуск/остановка foreground-сервиса геолокации.
///
/// Каждый цикл получает текущую позицию, кладёт её в очередь
/// `pending_actions` и сразу отправляет накопленные координаты пакетом.
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
/// Периодически (onRepeatEvent) получает позицию, сохраняет её
/// в локальную очередь [PendingActionStore] и тут же пытается отправить
/// накопленные координаты через [SyncRepository].
@pragma('vm:entry-point')
class LocationTaskHandler extends TaskHandler {
  /// Защита от наложения flush при быстрых повторных событиях.
  bool _flushing = false;

  /// Флаг готовности DI. Если инициализация в [onStart] не удалась,
  /// [onRepeatEvent] будет пытаться переинициализировать DI.
  bool _diReady = true;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _diReady = await _initDi();
    if (_diReady) await _collect();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    if (!_diReady) {
      _initDi().then((ready) {
        _diReady = ready;
        if (ready) _collect();
      });
      return;
    }
    _collect();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Нечего освобождать.
  }

  Future<bool> _initDi() async {
    try {
      await setupDependencies(AppConfig.production);
      return true;
    } catch (e, st) {
      debugPrint('Не удалось инициализировать DI в foreground-сервисе: $e\n$st');
      return false;
    }
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
      await _flushCoordinates();
    } catch (e, st) {
      debugPrint('Ошибка сбора координат: $e\n$st');
    }
  }

  Future<void> _flushCoordinates() async {
    if (_flushing) return;
    _flushing = true;
    try {
      await flushCoordinateActions(
        store: PendingActionStore.instance,
        syncRepository: getIt<SyncRepository>(),
      );
    } finally {
      _flushing = false;
    }
  }
}

/// Пытается отправить накопленные координатные действия и удаляет их из очереди.
///
/// Вынесено в отдельную функцию для тестирования без запуска foreground-сервиса.
Future<void> flushCoordinateActions({
  required PendingActionStore store,
  required SyncRepository syncRepository,
}) async {
  final actions = await store.readPending();
  final coordinateActions = actions
      .where((a) => a.type == PendingActionType.coordinates)
      .toList();
  if (coordinateActions.isEmpty) return;

  final points = geoPointsFromActions(coordinateActions);
  try {
    await syncRepository.sendCoordinates(points);
  } catch (e) {
    debugPrint('Ошибка отправки координат: $e');
    // Оставляем в очереди; следующий цикл или WorkManager повторят.
    return;
  }
  final ids = coordinateActions.map((a) => a.id).whereType<int>();
  await store.removeAll(ids);
}
