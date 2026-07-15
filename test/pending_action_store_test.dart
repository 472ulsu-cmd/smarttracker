import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/pending_action_store.dart';
import 'package:smarttracker/domain/models/pending_action.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Directory tempDir;

  setUp(() async {
    await PendingActionStore.instance.close();
    tempDir = await Directory.systemTemp.createTemp('smarttracker_test_');
    await databaseFactory.setDatabasesPath(tempDir.path);
  });

  tearDown(() async {
    await PendingActionStore.instance.close();
    await tempDir.delete(recursive: true);
  });

  group('PendingActionStore.removeAll', () {
    test('удаляет переданные идентификаторы', () async {
      final id1 = await PendingActionStore.instance.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {'lat': 55.0, 'lng': 37.0},
        ),
      );
      final id2 = await PendingActionStore.instance.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {'lat': 56.0, 'lng': 38.0},
        ),
      );
      await PendingActionStore.instance.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {'lat': 57.0, 'lng': 39.0},
        ),
      );

      await PendingActionStore.instance.removeAll([id1, id2]);

      final remaining = await PendingActionStore.instance.readPending();
      expect(remaining.length, 1);
      expect(remaining.first.payload['lat'], 57.0);
    });

    test('не падает и не удаляет записи при пустом списке', () async {
      await PendingActionStore.instance.enqueue(
        PendingAction(
          type: PendingActionType.coordinates,
          payload: {'lat': 55.0, 'lng': 37.0},
        ),
      );

      await PendingActionStore.instance.removeAll([]);

      final remaining = await PendingActionStore.instance.readPending();
      expect(remaining.length, 1);
    });
  });
}
