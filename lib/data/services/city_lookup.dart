import 'dart:math' as math;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;

/// Одна запись города из офлайн-БД.
class CityRecord {
  const CityRecord({
    required this.name,
    required this.lat,
    required this.lng,
    required this.countryCode,
  });

  final String name;
  final double lat;
  final double lng;
  final String countryCode;
}

/// Офлайн reverse-geocoding: поиск ближайшего города из встроенной БД
/// (assets/cities/cities.csv — города РФ, Казахстана, Беларуси).
///
/// Работает без сети — важно для фоновой отправки координат.
/// Точность ограничена покрытием БД (вдали от крупных городов погрешность
/// может достигать десятков километров).
class CityLookup {
  CityLookup._();
  static final CityLookup instance = CityLookup._();

  /// Конструктор только для тестов: инъекция готового списка городов.
  @visibleForTesting
  CityLookup.forTest(List<CityRecord> cities)
      : _cities = cities,
        _loaded = true;

  static const _assetPath = 'assets/cities/cities.csv';

  List<CityRecord>? _cities;
  bool _loaded = false;

  /// Загрузить и распарсить БД городов. Безопасно вызывать повторно.
  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString(_assetPath);
      _cities = _parseCsv(raw);
    } catch (_) {
      _cities = const [];
    }
    _loaded = true;
  }

  /// Найти ближайший город к точке. Возвращает null, если БД пуста.
  CityRecord? nearest(double lat, double lng) {
    final cities = _cities;
    if (cities == null || cities.isEmpty) return null;

    CityRecord? best;
    double bestDist = double.infinity;
    final cosLat = math.cos(lat * math.pi / 180.0);

    for (final c in cities) {
      // Дельты в градусах с поправкой cos(lat) для долготы (плоская аппроксимация).
      final dLat = c.lat - lat;
      final dLng = (c.lng - lng) * cosLat;
      final distSq = dLat * dLat + dLng * dLng;
      if (distSq < bestDist) {
        bestDist = distSq;
        best = c;
      }
    }
    return best;
  }

  /// Удобный метод: загрузить (если ещё не загружено) и вернуть название города.
  /// При ошибке/пустой БД возвращает [fallback].
  Future<String> resolveName(double lat, double lng,
      {String fallback = 'Неизвестно'}) async {
    await load();
    return nearest(lat, lng)?.name ?? fallback;
  }

  List<CityRecord> _parseCsv(String raw) {
    final result = <CityRecord>[];
    for (final line in raw.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final parts = trimmed.split(',');
      if (parts.length < 3) continue;
      final lat = double.tryParse(parts[1]);
      final lng = double.tryParse(parts[2]);
      if (lat == null || lng == null) continue;
      result.add(CityRecord(
        name: parts[0],
        lat: lat,
        lng: lng,
        countryCode: parts.length >= 4 ? parts[3] : '',
      ));
    }
    return result;
  }
}
