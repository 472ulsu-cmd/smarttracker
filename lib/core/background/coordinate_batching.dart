import '../../domain/models/geo_point.dart';
import '../../domain/models/pending_action.dart';

/// Извлекает координаты из ожидающих действий типа [PendingActionType.coordinates].
List<GeoPoint> geoPointsFromActions(List<PendingAction> actions) {
  final points = <GeoPoint>[];
  for (final action in actions) {
    if (action.type != PendingActionType.coordinates) continue;
    final payload = action.payload;
    points.add(
      GeoPoint(
        lat: (payload['lat'] as num).toDouble(),
        lng: (payload['lng'] as num).toDouble(),
        datetime: _parseStoredDatetime(payload['datetime'] as String),
        nearestCity: (payload['nearest_city'] ?? '') as String,
      ),
    );
  }
  return points;
}

/// Разбор строки, сохранённой в [GeoPoint.toJson]:
/// `2024-06-15 07:30:00+0000` → DateTime.
DateTime _parseStoredDatetime(String stored) {
  final iso = stored.length >= 11
      ? '${stored.substring(0, 10)}T${stored.substring(11)}'
      : stored;
  return DateTime.parse(iso);
}
