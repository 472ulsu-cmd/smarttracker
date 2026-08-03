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

  /// Время в формате бэкенда `date_format:Y-m-d H:i:sO`.
  ///
  /// Wall-clock-значение — аргентинское время (ART = UTC−3), а смещение в
  /// строке подписано как `+0000` — так требует бэкенд. Пример: для момента
  /// 07:30:00 UTC строка имеет вид `2024-06-15 04:30:00+0000` (07:30 − 3ч).
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'datetime': _formatArt(datetime),
        'nearest_city': nearestCity,
      };
}

/// Аргентинское wall-clock-время (ART = UTC−3) с суффиксом `+0000`
/// (требование бэкенда): `2024-06-15 04:30:00+0000`.
///
/// ВАЖНО: смещение `+0000` в строке не отражает истинный сдвиг момента —
/// это договорённость с бэкендом. Парсер [_parseStoredDatetime] в
/// `coordinate_batching.dart` компенсирует это прибавлением 3 часов, иначе
/// цикл «ошибка отправки → повтор» накапливал бы сдвиг −3ч на каждой итерации.
String _formatArt(DateTime dt) {
  final art = dt.toUtc().subtract(const Duration(hours: 3));
  String two(int v) => v.toString().padLeft(2, '0');
  return '${art.year.toString().padLeft(4, '0')}-'
      '${two(art.month)}-${two(art.day)} '
      '${two(art.hour)}:${two(art.minute)}:${two(art.second)}+0000';
}
