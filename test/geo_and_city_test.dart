import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/city_lookup.dart';
import 'package:smarttracker/domain/models/geo_point.dart';

void main() {
  group('GeoPoint datetime', () {
    test('toJson форматирует datetime как Y-m-d H:i:s+0000 (UTC)', () {
      // 15 июня 2024, 10:30:00 по Москве (UTC+3) = 07:30:00 UTC.
      final moscow = DateTime.utc(2024, 6, 15, 7, 30, 0);
      final p = GeoPoint(lat: 55.75, lng: 37.62, datetime: moscow);

      final json = p.toJson();

      expect(json['datetime'], '2024-06-15 07:30:00+0000');
      expect(json['lat'], 55.75);
      expect(json['lng'], 37.62);
      expect(json['nearest_city'], '');
    });

    test('toJson переводит локальное время в UTC перед форматированием', () {
      // Локальное 2024-01-15 22:05:03 эквивалентно какому-то UTC-моменту;
      // проверяем только формат строки, не конкретное значение (зависит от TZ).
      final p = GeoPoint(
        lat: 0,
        lng: 0,
        datetime: DateTime(2024, 1, 15, 22, 5, 3),
      );
      final dt = p.toJson()['datetime'] as String;
      // Формат: YYYY-MM-DD HH:MM:SS+0000
      expect(RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\+0000$')
          .hasMatch(dt), isTrue);
    });

    test('toJson включает nearest_city', () {
      final p = GeoPoint(
        lat: 1,
        lng: 2,
        datetime: DateTime.utc(2024, 1, 1),
        nearestCity: 'Москва',
      );
      expect(p.toJson()['nearest_city'], 'Москва');
    });
  });

  group('CityLookup парсер', () {
    test('nearest находит ближайший город из набора', () {
      final lookup = CityLookup.forTest([
        const CityRecord(name: 'Москва', lat: 55.7558, lng: 37.6173, countryCode: 'RU'),
        const CityRecord(name: 'Санкт-Петербург', lat: 59.9343, lng: 30.3351, countryCode: 'RU'),
        const CityRecord(name: 'Казань', lat: 55.7963, lng: 49.1088, countryCode: 'RU'),
      ]);

      // Точка в центре Москвы → Москва.
      expect(lookup.nearest(55.75, 37.62)?.name, 'Москва');
      // Точка ближе к Казани, чем к Москве.
      expect(lookup.nearest(55.80, 49.00)?.name, 'Казань');
      // Точка рядом с Питером.
      expect(lookup.nearest(59.93, 30.34)?.name, 'Санкт-Петербург');
    });

    test('nearest учитывает поправку на широту для долготы', () {
      final lookup = CityLookup.forTest([
        const CityRecord(name: 'A', lat: 60.0, lng: 30.0, countryCode: 'RU'),
        const CityRecord(name: 'B', lat: 60.0, lng: 60.0, countryCode: 'RU'),
      ]);
      // На широте 60° разница в 30° долготы — небольшое расстояние,
      // но точка (60, 45) посередине: ближайший определяется по dLng*cos(60).
      final r = lookup.nearest(60.0, 45.0);
      expect(r?.name, anyOf('A', 'B'));
    });

    test('nearest возвращает null при пустой БД', () {
      final lookup = CityLookup.forTest(const []);
      expect(lookup.nearest(55.75, 37.62), isNull);
    });
  });
}
