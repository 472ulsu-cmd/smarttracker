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

  /// Время в формате бэкенда `date_format:Y-m-d H:i:sO` — московское, UTC+3.
  ///
  /// MSK зафиксирован на UTC+3 без сезонного перевода часов (с 2014 года).
  /// Пример: `2024-06-15 10:30:00+0300` (для момента 07:30:00 UTC).
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'datetime': _formatMsk(datetime),
        'nearest_city': nearestCity,
      };
}

/// Московское время в формате `Y-m-d H:i:sO` (PHP) ↔ `yyyy-MM-dd HH:mm:ssZZZ`
/// (Dart): `2024-06-15 10:30:00+0300`. Суффикс `+0300` захардкожен — MSK не
/// имеет сезонного перевода.
String _formatMsk(DateTime dt) {
  final msk = dt.toUtc().add(const Duration(hours: 3));
  String two(int v) => v.toString().padLeft(2, '0');
  return '${msk.year.toString().padLeft(4, '0')}-'
      '${two(msk.month)}-${two(msk.day)} '
      '${two(msk.hour)}:${two(msk.minute)}:${two(msk.second)}+0300';
}
