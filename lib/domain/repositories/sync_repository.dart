import '../models/geo_point.dart';
import '../models/sync_config.dart';

/// Контракт репозитория синхронизации.
abstract class SyncRepository {
  /// Отправить массив координат (`POST /coordinates`).
  Future<void> sendCoordinates(List<GeoPoint> points);

  /// Получить периоды синхронизации (`GET /sync`).
  Future<SyncConfig> fetchSyncConfig();
}
