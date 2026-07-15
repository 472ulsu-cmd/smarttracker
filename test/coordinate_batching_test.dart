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
            'datetime': '2026-07-15 10:00:00+0000',
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
        DateTime.parse('2026-07-15T10:00:00+0000'),
      );
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
