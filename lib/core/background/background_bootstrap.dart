import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../config/service_locator.dart';
import '../../data/services/settings_service.dart';
import '../../data/services/sync_config_service.dart';
import '../../domain/models/sync_config.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'location_service.dart';
import 'push_service.dart';
import 'sync_service.dart';

/// Управление жизненным циклом фоновых сервисов.
///
/// Стартуют после успешного входа, останавливаются при выходе.
class BackgroundBootstrap {
  BackgroundBootstrap._();
  static final BackgroundBootstrap instance = BackgroundBootstrap._();

  PushService? _pushService;
  bool _firebaseReady = false;

  /// Одноразовая инициализация Firebase и workmanager.
  Future<void> initCore() async {
    try {
      await Firebase.initializeApp();
      _firebaseReady = true;
    } catch (e, st) {
      // google-services.json / GoogleService-Info.plist могут отсутствовать
      // в debug или быть некорректными — не блокируем приложение, но логируем:
      // без этой диагностики «не работают пуши» превращается в чёрный ящик.
      debugPrint('background: Firebase.initializeApp failed: $e\n$st');
      _firebaseReady = false;
    }
    try {
      await SyncService.instance.init();
    } catch (e, st) {
      // workmanager может быть недоступен на десктопе — игнорируем.
      debugPrint('background: SyncService.init failed: $e\n$st');
    }
    try {
      LocationService.instance.init();
    } catch (e, st) {
      // На платформах без foreground — игнорируем.
      debugPrint('background: LocationService.init failed: $e\n$st');
    }
  }

  /// Запустить все фоновые сервисы (после входа).
  Future<void> start() async {
    final config = getIt<SyncConfigService>().load();

    // Синхронизация.
    try {
      await SyncService.instance.schedule(
        period: Duration(
          seconds: config.syncPeriodSec < SyncConfig.minSyncPeriodSec
              ? SyncConfig.minSyncPeriodSec
              : config.syncPeriodSec,
        ),
      );
    } catch (_) {
      try {
        await SyncService.instance.schedule();
      } catch (_) {}
    }

    // Геолокация.
    try {
      await LocationService.instance.stop();
      await LocationService.instance.start(
        intervalMs: config.coordinatesPeriodSec * 1000,
      );
    } catch (e, st) {
      debugPrint('background: LocationService.start failed: $e\n$st');
    }

    // Push.
    if (_firebaseReady) {
      try {
        _pushService = PushService(
          getIt<NotificationsRepository>(),
          getIt<SettingsService>(),
        );
        await _pushService!.init();
      } catch (e, st) {
        debugPrint('background: PushService.init failed: $e\n$st');
      }
    } else {
      debugPrint('background: Push-сервис пропущен — Firebase не инициализирован');
    }
  }

  /// Остановить все фоновые сервисы (при выходе).
  Future<void> stop() async {
    _pushService?.dispose();
    _pushService = null;
    try {
      await SyncService.instance.cancel();
    } catch (_) {}
    try {
      await LocationService.instance.stop();
    } catch (_) {}
  }
}
