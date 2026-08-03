import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/core/background/coordinate_batching.dart';
import 'package:smarttracker/domain/models/pending_action.dart';

void main() {
  group('geoPointsFromActions', () {
    test('мапит координатные действия в GeoPoint', () {
      final actions = [
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {
            'lat': 55.75,
            'lng': 37.61,
            // ART wall-clock с псевдо-смещением +0000 (формат GeoPoint.toJson):
            // 04:00 — это ART (UTC-3), истинный момент 07:00 UTC. Парсер
            // прибавляет 3 часа, компенсируя литеральное чтение +0000.
            'datetime': '2026-07-15 04:00:00+0000',
            'nearest_city': 'Москва',
          },
        ),
      ];

      final points = geoPointsFromActions(actions);

      expect(points.length, 1);
      expect(points.first.lat, 55.75);
      expect(points.first.lng, 37.61);
      expect(points.first.nearestCity, 'Москва');
      expect(
        points.first.datetime,
        DateTime.parse('2026-07-15T07:00:00+0000'),
      );
    });

    test('цикл очередь→повтор не накапливает сдвиг', () {
      // Защита регрессии: строка из payload (ART + псевдо-+0000) должна
      // парситься в истинный UTC-момент, а повторная сериализация давать
      // ту же строку. Без прибавления 3ч в парсере каждый цикл сдвигал бы -3ч.
      final stored = '2026-07-15 04:00:00+0000';
      final actions = [
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {
            'lat': 0,
            'lng': 0,
            'datetime': stored,
            'nearest_city': '',
          },
        ),
      ];

      final reparsed = geoPointsFromActions(actions).first.toJson()['datetime'] as String;

      expect(reparsed, stored);
    });

    test('пропускает не-координатные действия', () {
      final actions = [
        PendingAction(
          type: PendingActionType.statusChange,
          payload: {'orderId': 1, 'statusId': 2},
        ),
      ];

      expect(geoPointsFromActions(actions), isEmpty);
    });
  });
}
