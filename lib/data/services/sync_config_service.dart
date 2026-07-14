import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/sync_config.dart';

/// Локальное хранилище конфигурации синхронизации (/sync).
class SyncConfigService {
  SyncConfigService();

  SharedPreferences? _prefs;

  static const _coordinatesKey = 'sync_coordinates_period';
  static const _syncKey = 'sync_sync_period';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> save(SyncConfig config) async {
    await _prefs?.setInt(_coordinatesKey, config.coordinatesPeriodSec);
    await _prefs?.setInt(_syncKey, config.syncPeriodSec);
  }

  SyncConfig load() {
    return SyncConfig(
      coordinatesPeriodSec: _prefs?.getInt(_coordinatesKey) ??
          const SyncConfig().coordinatesPeriodSec,
      syncPeriodSec: _prefs?.getInt(_syncKey) ??
          const SyncConfig().syncPeriodSec,
    );
  }
}
