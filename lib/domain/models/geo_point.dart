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
  /// Wall-clock-значение — UTC (без сдвига), но смещение в строке подписано
  /// как `-0300` — так требует бэкенд. Пример: для момента 07:30:00 UTC
  /// строка имеет вид `2024-06-15 07:30:00-0300`.
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'datetime': _formatUtc(datetime),
        'nearest_city': nearestCity,
      };
}

/// UTC wall-clock с суффиксом `-0300` (требование бэкенда):
/// `2024-06-15 07:30:00-0300`.
///
/// ВАЖНО: смещение `-0300` в строке не отражает часовой пояс момента — это
/// договорённость с бэкендом. Парсер [_parseStoredDatetime] в
/// `coordinate_batching.dart` компенсирует это вычитанием 3 часов, иначе
/// цикл «ошибка отправки → повтор» накапливал бы сдвиг +3ч на каждой итерации.
String _formatUtc(DateTime dt) {
  final utc = dt.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${utc.year.toString().padLeft(4, '0')}-'
      '${two(utc.month)}-${two(utc.day)} '
      '${two(utc.hour)}:${two(utc.minute)}:${two(utc.second)}-0300';
}
