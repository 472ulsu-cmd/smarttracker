# Автоматическая фоновая отправка координат по `/sync` — план реализации

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Сделать так, чтобы координаты отправлялись автоматически, в том числе в фоне, с периодом `coordinates_period` из `GET /sync`.

**Architecture:** Foreground-сервис `LocationService` при каждом цикле будет не только собирать точку, но и сразу пытаться отправить накопленный батч на `/coordinates`. `WorkManager` (`SyncService`) останется резервным каналом: его callback инициализирует DI и отправляет накопленные координаты пакетом с периодом `sync_period`. Общая чистая логика маппинга очереди в `List<GeoPoint>` выносится в `coordinate_batching.dart`.

**Tech Stack:** Flutter/Dart, `flutter_foreground_task`, `workmanager`, `get_it`, `sqflite`, `dio`, `flutter_test`.

## Global Constraints

- Период сбора/отправки из foreground: `SyncConfig.coordinatesPeriodSec` (для тестового пользователя = 1200 сек).
- Период резервной фоновой синхронизации: `SyncConfig.syncPeriodSec` (минимум 900 сек из-за ограничения WorkManager).
- Формат тела `POST /coordinates`: массив объектов `GeoPoint.toJson()` (`lat`, `lng`, `datetime`, `nearest_city`).
- `WorkManager`-callback выполняется в отдельном isolate; DI нужно инициализировать внутри него.
- Сборка (build) не выполняется по запросу пользователя; проверка через `flutter analyze` и `flutter test`.

---

### Task 1: Вспомогательный модуль для батчинга координат

**Files:**
- Create: `lib/core/background/coordinate_batching.dart`
- Modify: `lib/data/services/pending_action_store.dart`
- Test: `test/coordinate_batching_test.dart`

**Interfaces:**
- Consumes: `PendingAction` из `lib/domain/models/pending_action.dart`.
- Produces: `List<GeoPoint> geoPointsFromActions(List<PendingAction> actions)`.

- [ ] **Step 1: Write the failing coordinate batching test**

```dart
// test/coordinate_batching_test.dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat test test/coordinate_batching_test.dart`

Expected: FAIL — `geoPointsFromActions` not found.

- [ ] **Step 3: Create `coordinate_batching.dart`**

```dart
// lib/core/background/coordinate_batching.dart
import '../../domain/models/geo_point.dart';
import '../../domain/models/pending_action.dart';

/// Извлекает координаты из ожидающих действий типа [PendingActionType.coordinates].
List<GeoPoint> geoPointsFromActions(List<PendingAction> actions) {
  final points = <GeoPoint>[];
  for (final action in actions) {
    if (action.type != PendingActionType.coordinates) continue;
    final payload = action.payload;
    points.add(
      GeoPoint(
        lat: (payload['lat'] as num).toDouble(),
        lng: (payload['lng'] as num).toDouble(),
        datetime: _parseStoredDatetime(payload['datetime'] as String),
        nearestCity: (payload['nearest_city'] ?? '') as String,
      ),
    );
  }
  return points;
}

/// Разбор строки, сохранённой в [GeoPoint.toJson]:
/// `2024-06-15 07:30:00+0000` → DateTime.
DateTime _parseStoredDatetime(String stored) {
  final iso = stored.length >= 11
      ? '${stored.substring(0, 10)}T${stored.substring(11)}'
      : stored;
  return DateTime.parse(iso);
}
```

- [ ] **Step 4: Add `removeAll` to `PendingActionStore`**

```dart
// lib/data/services/pending_action_store.dart
/// Удалить несколько действий (после успешной пакетной отправки).
Future<void> removeAll(Iterable<int> ids) async {
  final db = await _database();
  final batch = db.batch();
  for (final id in ids) {
    batch.delete(_table, where: '$_colId = ?', whereArgs: [id]);
  }
  await batch.commit(noResult: true);
}
```

- [ ] **Step 5: Run tests**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat test test/coordinate_batching_test.dart`

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/background/coordinate_batching.dart lib/data/services/pending_action_store.dart test/coordinate_batching_test.dart
git commit -m "feat(background): coordinate batching helper and batch remove"
```

---

### Task 2: Инициализация DI и пакетная отправка в `WorkManager`

**Files:**
- Modify: `lib/core/background/sync_service.dart`

**Interfaces:**
- Consumes: `setupDependencies(const AppConfig.production())`, `geoPointsFromActions`, `PendingActionStore.removeAll`.
- Produces: `syncCallbackDispatcher` теперь инициализирует DI и шлёт координаты пакетом.

- [ ] **Step 1: Update imports in `sync_service.dart`**

```dart
import '../../config/app_config.dart';
import '../../config/service_locator.dart';
import 'coordinate_batching.dart';
```

- [ ] **Step 2: Rewrite `syncCallbackDispatcher`**

```dart
@pragma('vm:entry-point')
void syncCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // WorkManager запускается в отдельном isolate — DI нужно инициализировать заново.
    await setupDependencies(const AppConfig.production());

    if (!getIt.isRegistered<OrdersRepository>()) return true;

    final store = PendingActionStore.instance;
    final actions = await store.readPending();

    final coordinateActions = <PendingAction>[];

    for (final action in actions) {
      if (action.type == PendingActionType.coordinates) {
        coordinateActions.add(action);
        continue;
      }

      try {
        await _process(action);
        if (action.id != null) await store.remove(action.id!);
      } catch (_) {
        if (action.id != null) await store.markFailedAttempt(action.id!);
      }
    }

    if (coordinateActions.isNotEmpty) {
      try {
        final points = geoPointsFromActions(coordinateActions);
        await getIt<SyncRepository>().sendCoordinates(points);
        final ids = coordinateActions.map((a) => a.id).whereType<int>();
        await store.removeAll(ids);
      } catch (_) {
        for (final action in coordinateActions) {
          if (action.id != null) await store.markFailedAttempt(action.id!);
        }
      }
    }

    return true;
  });
}
```

- [ ] **Step 3: Remove per-coordinate handling from `_process`**

Leave only `statusChange` and `photoUpload` cases. Delete the `PendingActionType.coordinates` branch.

- [ ] **Step 4: Remove unused `_parseStoredDatetime` from `sync_service.dart`**

It now lives in `coordinate_batching.dart`.

- [ ] **Step 5: Run analyze**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat analyze`

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/core/background/sync_service.dart
git commit -m "feat(background): init DI and batch-send coordinates from WorkManager"
```

---

### Task 3: Отправка координат прямо из foreground-сервиса

**Files:**
- Modify: `lib/core/background/location_service.dart`

**Interfaces:**
- Consumes: `setupDependencies`, `getIt<SyncRepository>()`, `geoPointsFromActions`, `PendingActionStore.removeAll`.
- Produces: `LocationTaskHandler.onStart` инициализирует DI; `_collect` отправляет батч после сохранения.

- [ ] **Step 1: Update imports**

```dart
import '../../config/app_config.dart';
import '../../config/service_locator.dart';
import '../../domain/repositories/sync_repository.dart';
import 'coordinate_batching.dart';
```

- [ ] **Step 2: Initialize DI in `onStart`**

```dart
@override
Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
  await setupDependencies(const AppConfig.production());
  await _collect();
}
```

- [ ] **Step 3: Flush coordinates after collection**

Update `_collect`:

```dart
Future<void> _collect() async {
  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      timeLimit: const Duration(seconds: 15),
    );
    final city = await CityLookup.instance
        .resolveName(position.latitude, position.longitude);
    final point = GeoPoint(
      lat: position.latitude,
      lng: position.longitude,
      datetime: DateTime.now(),
      nearestCity: city,
    );
    await PendingActionStore.instance.enqueue(PendingAction(
      type: PendingActionType.coordinates,
      payload: point.toJson(),
      createdAt: DateTime.now(),
    ));
    await _flushCoordinates();
  } catch (_) {
    // Тихо игнорируем ошибки отдельного цикла.
  }
}
```

- [ ] **Step 4: Add `_flushCoordinates`**

```dart
Future<void> _flushCoordinates() async {
  try {
    final store = PendingActionStore.instance;
    final actions = await store.readPending();
    final coordinateActions = actions
        .where((a) => a.type == PendingActionType.coordinates)
        .toList();
    if (coordinateActions.isEmpty) return;

    final points = geoPointsFromActions(coordinateActions);
    await getIt<SyncRepository>().sendCoordinates(points);
    final ids = coordinateActions.map((a) => a.id).whereType<int>();
    await store.removeAll(ids);
  } catch (_) {
    // Оставляем в очереди; следующий цикл или WorkManager повторят.
  }
}
```

- [ ] **Step 5: Run analyze**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat analyze`

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/core/background/location_service.dart
git commit -m "feat(background): send coordinate batch from foreground service"
```

---

### Task 4: Тесты для `SyncRepositoryImpl.sendCoordinates`

**Files:**
- Create: `test/sync_repository_test.dart`

- [ ] **Step 1: Write tests**

```dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/repositories/sync_repository_impl.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/geo_point.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.throwError});

  final Object? throwError;
  RequestOptions? captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    if (throwError != null) {
      throw throwError!;
    }
    return ResponseBody.fromString('', 200);
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWithAdapter(HttpClientAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://st.b2b-logist.com/api/'))
      ..httpClientAdapter = adapter;

GeoPoint _point(double lat, double lng, String city) => GeoPoint(
      lat: lat,
      lng: lng,
      datetime: DateTime.parse('2026-07-15T10:00:00Z'),
      nearestCity: city,
    );

void main() {
  group('SyncRepositoryImpl.sendCoordinates', () {
    test('отправляет POST /coordinates с массивом точек', () async {
      final adapter = _FakeAdapter();
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      await repo.sendCoordinates([
        _point(55.75, 37.61, 'Москва'),
        _point(56.83, 60.60, 'Екатеринбург'),
      ]);

      expect(adapter.captured?.method, 'POST');
      expect(adapter.captured?.path, '/coordinates');
      final data = adapter.captured?.data as List<dynamic>;
      expect(data.length, 2);
      expect(data.first['lat'], 55.75);
      expect(data.first['nearest_city'], 'Москва');
    });

    test('пустой список не вызывает запрос', () async {
      final adapter = _FakeAdapter();
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      await repo.sendCoordinates([]);

      expect(adapter.captured, isNull);
    });

    test('пробрасывает NetworkException при сетевой ошибке', () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/coordinates'),
          type: DioExceptionType.connectionError,
          error: Exception('no connection'),
        ),
      );
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendCoordinates([_point(55.0, 37.0, '')]),
        throwsA(isA<NetworkException>()),
      );
    });

    test('пробрасывает AppException из cause', () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/coordinates'),
          type: DioExceptionType.badResponse,
          error: const ValidationException(),
        ),
      );
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendCoordinates([_point(55.0, 37.0, '')]),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run tests**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat test test/sync_repository_test.dart`

Expected: PASS.

- [ ] **Step 3: Commit**

```bash
git add test/sync_repository_test.dart
git commit -m "test(sync): add SyncRepositoryImpl.sendCoordinates tests"
```

---

### Task 5: Финальная верификация

**Files:**
- All of the above.

- [ ] **Step 1: Run full analyze**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat analyze`

Expected: `No issues found!`

- [ ] **Step 2: Run full test suite**

Run: `/c/Users/A.Sobyanin/flutter/bin/flutter.bat test`

Expected: all tests pass.

- [ ] **Step 3: Commit any fixes**

```bash
git add -A
git commit -m "fix: address analyze/test issues after coordinate background sending"
```

---

## Spec Coverage Checklist

- [x] Foreground-сервис отправляет координаты с периодом `coordinatesPeriodSec` — Task 3.
- [x] `WorkManager`-callback инициализирует DI — Task 2.
- [x] `WorkManager` отправляет координаты пакетом — Task 2.
- [x] Формат тела `POST /coordinates` не меняется — Tasks 2–3 используют `GeoPoint.toJson()`.
- [x] Резервная отправка при убитом приложении сохраняется — Task 2.
- [x] Тесты на сетевой слой и маппинг — Tasks 1, 4.
- [x] `flutter analyze` / `flutter test` — Task 5.
