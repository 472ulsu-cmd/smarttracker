import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/core/background/location_service.dart';
import 'package:smarttracker/data/services/pending_action_store.dart';
import 'package:smarttracker/domain/models/geo_point.dart';
import 'package:smarttracker/domain/models/pending_action.dart';
import 'package:smarttracker/domain/models/sync_config.dart';
import 'package:smarttracker/domain/repositories/sync_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _FakeSyncRepository implements SyncRepository {
  List<List<GeoPoint>> sent = [];
  Object? error;

  @override
  Future<void> sendCoordinates(List<GeoPoint> points) async {
    if (error != null) throw error!;
    sent.add(points);
  }

  @override
  Future<SyncConfig> fetchSyncConfig() async => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Directory tempDir;
  late _FakeSyncRepository syncRepository;

  setUp(() async {
    await PendingActionStore.instance.close();
    tempDir = await Directory.systemTemp.createTemp('smarttracker_test_');
    await databaseFactory.setDatabasesPath(tempDir.path);
    syncRepository = _FakeSyncRepository();
  });

  tearDown(() async {
    await PendingActionStore.instance.close();
    await tempDir.delete(recursive: true);
  });

  group('flushCoordinateActions', () {
    test('отправляет накопленные координаты и удаляет их из очереди',
        () async {
      final store = PendingActionStore.instance;
      await store.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: _pointPayload(55.75, 37.61, 'Москва'),
        ),
      );
      await store.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: _pointPayload(56.83, 60.60, 'Екатеринбург'),
        ),
      );
      await store.enqueue(
        PendingAction(
          type: PendingActionType.statusChange,
          payload: {'orderId': 1, 'statusId': 2},
        ),
      );

      await flushCoordinateActions(
        store: store,
        syncRepository: syncRepository,
      );

      expect(syncRepository.sent.length, 1);
      expect(syncRepository.sent.first.length, 2);
      expect(syncRepository.sent.first.first.lat, 55.75);
      expect(syncRepository.sent.first.last.nearestCity, 'Екатеринбург');

      final remaining = await store.readPending();
      expect(remaining.length, 1);
      expect(remaining.first.type, PendingActionType.statusChange);
    });

    test('при ошибке отправки оставляет координаты в очереди', () async {
      final store = PendingActionStore.instance;
      await store.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: _pointPayload(55.0, 37.0, 'Москва'),
        ),
      );
      syncRepository.error = Exception('network');

      await flushCoordinateActions(
        store: store,
        syncRepository: syncRepository,
      );

      expect(syncRepository.sent, isEmpty);
      final remaining = await store.readPending();
      expect(remaining.length, 1);
    });

    test('ничего не делает, если очередь пуста', () async {
      await flushCoordinateActions(
        store: PendingActionStore.instance,
        syncRepository: syncRepository,
      );

      expect(syncRepository.sent, isEmpty);
    });

    test('extra-точка уходит с пакетом, при ошибке попадает в очередь',
        () async {
      final store = PendingActionStore.instance;
      final point = GeoPoint(
        lat: 59.9,
        lng: 30.3,
        datetime: DateTime.parse('2026-07-15T11:00:00Z'),
        nearestCity: 'Санкт-Петербург',
      );

      // Успех: точка уходит напрямую, очередь не трогается.
      await flushCoordinateActions(
        store: store,
        syncRepository: syncRepository,
        extra: point,
      );
      expect(syncRepository.sent.single.single.lat, 59.9);
      expect(await store.readPending(), isEmpty);

      // Ошибка: точка сохраняется в очередь для повтора.
      syncRepository.error = Exception('network');
      await flushCoordinateActions(
        store: store,
        syncRepository: syncRepository,
        extra: point,
      );
      final pending = await store.readPending();
      expect(pending.single.payload['lat'], 59.9);
    });

    test('пропускает повреждённые payload и отправляет остальные',
        () async {
      final store = PendingActionStore.instance;
      await store.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {'lat': 'invalid', 'lng': 37.0},
        ),
      );
      await store.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: _pointPayload(56.0, 38.0, ''),
        ),
      );

      await flushCoordinateActions(
        store: store,
        syncRepository: syncRepository,
      );

      expect(syncRepository.sent.length, 1);
      expect(syncRepository.sent.first.length, 1);
      expect(syncRepository.sent.first.first.lat, 56.0);

      // После успешной отправки все координатные действия удалены,
      // включая повреждённые записи, которые не удалось распарсить.
      final remaining = await store.readPending();
      expect(remaining.length, 0);
    });
  });
}

Map<String, dynamic> _pointPayload(double lat, double lng, String city) {
  return GeoPoint(
    lat: lat,
    lng: lng,
    datetime: DateTime.parse('2026-07-15T10:00:00Z'),
    nearestCity: city,
  ).toJson();
}
