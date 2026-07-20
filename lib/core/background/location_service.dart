import 'dart:async';

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
/// Каждый цикл получает текущую позицию и отправляет её на сервер
/// вместе с накопленными в очереди точками. В очередь `pending_actions`
/// точка попадает только при ошибке отправки.
///
/// Требуется разрешение `LocationPermission.always`.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  static const _notificationChannelId = 'smarttracker_location';
  static const _notificationTitle = 'Умный Водитель';

  /// Интервал сбора координат по умолчанию (60 секунд, из SyncConfig).
  int intervalMs = 60000;

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

    // На Android 13+ уведомление foreground-сервиса не покажется без
    // явного запроса POST_NOTIFICATIONS. Без разрешения система не даёт
    // поднять сервис вообще — поэтому запрашиваем до старта.
    try {
      final perm = await FlutterForegroundTask.requestNotificationPermission();
      debugPrint('foreground: notification permission = ${perm.name}');
    } catch (e, st) {
      debugPrint('foreground: requestNotificationPermission failed: $e\n$st');
    }

    // startCallback — top-level функция с @pragma('vm:entry-point'):
    // плагин v10+ регистрирует TaskHandler в отдельном изоляте через неё.
    try {
      final result = await FlutterForegroundTask.startService(
        notificationTitle: _notificationTitle,
        notificationText: 'Передача геопозиции…',
        callback: startCallback,
      );
      if (result is ServiceRequestFailure) {
        debugPrint('foreground: startService failed: ${result.error}');
      } else {
        debugPrint('foreground: service started successfully');
      }
    } catch (e, st) {
      debugPrint('foreground: startService exception: $e\n$st');
    }
  }

  /// Остановить foreground-сервис.
  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}

/// Точка входа для изолята foreground-сервиса (обязательно top-level).
///
/// Регистрирует [LocationTaskHandler] в изоляте, в котором крутится сервис.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

/// Обработчик фоновой задачи геолокации.
///
/// Периодически (onRepeatEvent) получает позицию и отправляет её через
/// [SyncRepository] вместе с накопленной очередью. В [PendingActionStore]
/// точка сохраняется только при ошибке отправки.
@pragma('vm:entry-point')
class LocationTaskHandler extends TaskHandler {
  /// Защита от наложения flush при быстрых повторных событиях.
  bool _flushing = false;

  /// Флаг готовности DI. Если инициализация в [onStart] не удалась,
  /// [onRepeatEvent] будет пытаться переинициализировать DI.
  bool _diReady = false;

  /// Защита от одновременной инициализации DI из [onStart] и [onRepeatEvent].
  Completer<bool>? _diCompleter;

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
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    // Нечего освобождать.
  }

  Future<bool> _initDi() async {
    if (_diCompleter != null && !_diCompleter!.isCompleted) {
      return _diCompleter!.future;
    }
    _diCompleter = Completer<bool>();
    try {
      await setupDependencies(AppConfig.production);
      _diCompleter!.complete(true);
      return true;
    } catch (e, st) {
      debugPrint('Не удалось инициализировать DI в foreground-сервисе: $e\n$st');
      _diCompleter!.complete(false);
      return false;
    }
  }

  Future<void> _collect() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
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
      await _flushCoordinates(point);
    } catch (e, st) {
      debugPrint('Ошибка сбора координат: $e\n$st');
    }
  }

  Future<void> _flushCoordinates(GeoPoint point) async {
    // Пока идёт другая отправка — кладём точку в очередь,
    // её заберёт следующий цикл.
    if (_flushing) {
      await PendingActionStore.instance.enqueue(PendingAction(
        type: PendingActionType.coordinates,
        payload: point.toJson(),
        createdAt: point.datetime,
      ));
      return;
    }
    _flushing = true;
    try {
      await flushCoordinateActions(
        store: PendingActionStore.instance,
        syncRepository: getIt<SyncRepository>(),
        extra: point,
      );
    } finally {
      _flushing = false;
    }
  }
}

/// Пытается отправить накопленные координатные действия и удаляет их из очереди.
///
/// Вынесено в отдельную функцию для тестирования без запуска foreground-сервиса.
///
/// [extra] — свежая точка, которой ещё нет в очереди: уходит тем же пакетом,
/// а при ошибке отправки сохраняется в очередь для повтора.
///
/// Повреждённые payload пропускаются при парсинге, но после успешной отправки
/// все coordinate-действия удаляются из очереди (включая нераспарсенные),
/// чтобы не засорять хранилище.
Future<void> flushCoordinateActions({
  required PendingActionStore store,
  required SyncRepository syncRepository,
  GeoPoint? extra,
}) async {
  final actions = await store.readPending();
  final coordinateActions = actions
      .where((a) => a.type == PendingActionType.coordinates)
      .toList();
  if (coordinateActions.isEmpty && extra == null) return;

  final points = geoPointsFromActions(coordinateActions);
  if (extra != null) points.add(extra);
  try {
    await syncRepository.sendCoordinates(points);
  } catch (e) {
    debugPrint('Ошибка отправки координат: $e');
    // Новую точку сохраняем в очередь; старые записи и так в ней.
    // Следующий цикл или WorkManager повторят.
    if (extra != null) {
      await store.enqueue(PendingAction(
        type: PendingActionType.coordinates,
        payload: extra.toJson(),
        createdAt: extra.datetime,
      ));
    }
    return;
  }
  final ids = coordinateActions.map((a) => a.id).whereType<int>();
  await store.removeAll(ids);
}
