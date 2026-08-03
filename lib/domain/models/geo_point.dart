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
  /// Wall-clock-значение — московское (UTC+3), но смещение в строке подписано
  /// как `+0000` — так требует бэкенд. Пример: для момента 07:30:00 UTC
  /// строка имеет вид `2024-06-15 10:30:00+0000` (часы 10:30 по Москве,
  /// суффикс +0000).
  ///
  /// MSK зафиксирован на UTC+3 без сезонного перевода часов (с 2014 года).
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
        'datetime': _formatMsk(datetime),
        'nearest_city': nearestCity,
      };
}

/// Московское wall-clock-время с суффиксом `+0000` (требование бэкенда):
/// `2024-06-15 10:30:00+0000`. MSK = UTC+3 без сезонного перевода.
///
/// ВАЖНО: смещение `+0000` в строке не отражает истинный сдвиг момента —
/// это договорённость с бэкендом. Парсер [_parseStoredDatetime] в
/// `coordinate_batching.dart` компенсирует это вычитанием 3 часов, иначе
/// цикл «ошибка отправки → повтор» накапливал бы сдвиг +3ч на каждой итерации.
String _formatMsk(DateTime dt) {
  final msk = dt.toUtc().add(const Duration(hours: 3));
  String two(int v) => v.toString().padLeft(2, '0');
  return '${msk.year.toString().padLeft(4, '0')}-'
      '${two(msk.month)}-${two(msk.day)} '
      '${two(msk.hour)}:${two(msk.minute)}:${two(msk.second)}+0000';
}
