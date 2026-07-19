import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../../config/app_config.dart';
import '../../config/service_locator.dart';
import '../../data/services/pending_action_store.dart';
import '../../domain/models/pending_action.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import 'location_service.dart';

/// Уникальное имя фоновой задачи синхронизации.
const syncTaskName = 'smarttracker-sync';

/// Точка входа фоновой задачи workmanager.
///
/// Читает ожидающие действия из [PendingActionStore] и выполняет
/// соответствующие HTTP-запросы через репозитории. При неудаче увеличивает
/// счётчик попыток; после 5 — помечает failed.
///
/// WorkManager запускается в отдельном isolate — DI нужно инициализировать
/// заново.
@pragma('vm:entry-point')
void syncCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // WorkManager запускается в отдельном isolate — DI нужно инициализировать заново.
    try {
      await setupDependencies(AppConfig.production);
    } catch (e, st) {
      debugPrint('Ошибка инициализации DI в фоновой синхронизации: $e\n$st');
      return false;
    }

    if (!getIt.isRegistered<OrdersRepository>()) {
      debugPrint('OrdersRepository не зарегистрирован после инициализации DI');
      return false;
    }

    final store = PendingActionStore.instance;
    final actions = await store.readPending();

    for (final action in actions) {
      // Координаты отправляются одним пакетом после цикла.
      if (action.type == PendingActionType.coordinates) continue;

      try {
        await _process(action);
        if (action.id != null) await store.remove(action.id!);
      } catch (e, st) {
        debugPrint('Ошибка обработки действия ${action.type}: $e\n$st');
        if (action.id != null) await store.markFailedAttempt(action.id!);
      }
    }

    // ponytail: координаты не помечаются failed (читателя failed-статуса
    // нет) — при перманентном сбое копятся в очереди, ~150 байт/запись.
    await flushCoordinateActions(
      store: store,
      syncRepository: getIt<SyncRepository>(),
    );

    return true;
  });
}

Future<void> _process(PendingAction action) async {
  final payload = action.payload;
  switch (action.type) {
    case PendingActionType.statusChange:
      await getIt<OrdersRepository>().changeStatus(
        (payload['orderId'] as num).toInt(),
        (payload['statusId'] as num).toInt(),
      );
      break;
    case PendingActionType.photoUpload:
      await getIt<PhotoRepository>().uploadPhotoByType(
        (payload['orderId'] as num).toInt(),
        (payload['routePhotoTypeId'] as num).toInt(),
        payload['filePath'] as String,
      );
      break;
    case PendingActionType.coordinates:
      // Координаты обрабатываются пакетным вызовом до входа в [_process].
      throw UnsupportedError(
        'Coordinates must be processed as a batch outside _process',
      );
  }
}

/// Регистрация фоновой задачи синхронизации.
class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  bool _initialized = false;

  /// Инициализация workmanager (вызывается один раз при старте приложения).
  Future<void> init() async {
    if (_initialized) return;
    await Workmanager().initialize(syncCallbackDispatcher);
    _initialized = true;
  }

  /// Планирование периодической фоновой синхронизации.
  /// Минимальный период — 15 минут.
  Future<void> schedule({Duration period = const Duration(minutes: 15)}) async {
    await Workmanager().registerPeriodicTask(
      syncTaskName,
      syncTaskName,
      frequency: period,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Отмена фоновой задачи (при выходе).
  Future<void> cancel() async {
    await Workmanager().cancelByUniqueName(syncTaskName);
  }
}
