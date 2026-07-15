/// Конфигурация периодов синхронизации (`GET /sync`).
class SyncConfig {
  const SyncConfig({
    this.coordinatesPeriodSec = 60,
    this.syncPeriodSec = 900,
  });

  /// Период отправки координат, секунд (по умолчанию 60).
  final int coordinatesPeriodSec;

  /// Период фоновой синхронизации, секунд (по умолчанию 900 = 15 мин, минимум 900).
  final int syncPeriodSec;

  /// Минимально допустимый период фоновой синхронизации (workmanager).
  static const int minSyncPeriodSec = 900;
}
