/// Геопозиция для отправки на сервер.
class GeoPoint {
  const GeoPoint({
    required this.lat,
    required this.lng,
    required this.datetime,
    this.nearestCity = '',
  });

  final double lat;
  final double lng;
  final DateTime datetime;
  final String nearestCity;

  /// Время в формате бэкенда `date_format:Y-m-d H:i:sO` — UTC со смещением.
  ///
  /// Универсальное время: момент времени по UTC, смещение +0000.
  /// Пример: `2024-06-15 07:30:00+0000`.
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'datetime': _formatUtcOffset(datetime),
        'nearest_city': nearestCity,
      };
}

/// Формат `Y-m-d H:i:sO` (PHP) ↔ `yyyy-MM-dd HH:mm:ssZZZ` в Dart:
/// `2024-06-15 07:30:00+0000`.
String _formatUtcOffset(DateTime dt) {
  final utc = dt.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  // Смещение UTC: +0000.
  return '${utc.year.toString().padLeft(4, '0')}-'
      '${two(utc.month)}-${two(utc.day)} '
      '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}+0000';
}
