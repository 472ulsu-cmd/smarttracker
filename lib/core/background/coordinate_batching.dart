import '../../domain/models/geo_point.dart';
import '../../domain/models/pending_action.dart';

/// Извлекает координаты из ожидающих действий типа [PendingActionType.coordinates].
///
/// Повреждённые payload пропускаются вместо исключений, чтобы одна
/// испорченная запись не блокировала отправку остальных.
List<GeoPoint> geoPointsFromActions(List<PendingAction> actions) {
  final points = <GeoPoint>[];
  for (final action in actions) {
    if (action.type != PendingActionType.coordinates) continue;
    final payload = action.payload;
    final lat = _asDouble(payload['lat']);
    final lng = _asDouble(payload['lng']);
    final datetime = _tryParseStoredDatetime(_asString(payload['datetime']));
    if (lat == null || lng == null || datetime == null) continue;
    points.add(
      GeoPoint(
        lat: lat,
        lng: lng,
        datetime: datetime,
        nearestCity: _asString(payload['nearest_city']) ?? '',
      ),
    );
  }
  return points;
}

double? _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? _asString(dynamic value) => value is String ? value : null;

DateTime? _tryParseStoredDatetime(String? stored) {
  if (stored == null) return null;
  try {
    return _parseStoredDatetime(stored);
  } on FormatException {
    return null;
  }
}

/// Разбор строки, сохранённой в [GeoPoint.toJson]:
/// `2024-06-15 10:30:00+0300` → DateTime (MSK-формат, смещение учитывается).
DateTime _parseStoredDatetime(String stored) {
  final iso = stored.length >= 11
      ? '${stored.substring(0, 10)}T${stored.substring(11)}'
      : stored;
  return DateTime.parse(iso);
}
