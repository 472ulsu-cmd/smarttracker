# Дизайн: автоматическая фоновая отправка координат по периоду `/sync`

## Контекст

Пользователь дал тестовые учётные данные и попросил:
1. Протестировать `POST /coordinates`.
2. Сделать так, чтобы координаты отправлялись автоматически, в том числе в фоне, с периодом, заданным в `GET /sync` (поле `coordinates_period`).

## Проверка API

- `POST /login` → `200`, токен получен.
- `GET /sync` → `{"coordinates_period": 1200, "sync_period": 1200}` (20 мин).
- `POST /coordinates` с телом `[{"lat":55.7558,"lng":37.6173,"datetime":"2026-07-15 03:50:00+0000","nearest_city":"Москва"}]` → `200 {"code":0}`.

Формат тела совпадает с `GeoPoint.toJson()`.

## Текущее состояние

- `LocationService` (foreground) собирает координаты каждые `coordinatesPeriodSec` и складывает их в `PendingActionStore` как `PendingActionType.coordinates`.
- `SyncService` (`WorkManager`) должен читать очередь и отправлять, но:
  - callback `syncCallbackDispatcher` не инициализирует DI, поэтому `getIt<SyncRepository>()` пуст;
  - отправляет точки по одной вместо пакета;
  - работает с периодом `syncPeriodSec`, а не `coordinatesPeriodSec`.
- `coordinates_period` из `/sync` сейчас влияет только на частоту сбора, не на отправку.

## Целевое поведение

Координаты отправляются автоматически с периодом `coordinatesPeriodSec` (для тестового пользователя — 20 мин). Отправка должна происходить в foreground-сервисе; `WorkManager` остаётся резервным механизмом на случай, если приложение было убито между циклами.

## Архитектура

### 1. Отправка из foreground-сервиса

`LocationTaskHandler.onRepeatEvent` после сбора точки:
1. Создаёт `GeoPoint` и кладёт в `PendingActionStore.enqueue(PendingActionType.coordinates, ...)`.
2. Читает все `pending` `coordinates`-записи из `PendingActionStore.readPending()`.
3. Преобразует их в `List<GeoPoint>`.
4. Вызывает `SyncRepository.sendCoordinates(points)`.
5. При успехе — удаляет отправленные записи.
6. При неуспехе — оставляет записи в очереди; они уйдут в следующем цикле или через `WorkManager`.

Период цикла foreground-сервиса задаётся `SyncConfig.coordinatesPeriodSec * 1000` в `BackgroundBootstrap.start()`.

### 2. Резервная отправка через WorkManager

`syncCallbackDispatcher`:
1. В самом начале вызывает `setupDependencies(AppConfig.production)` (или минимальный набор, достаточный для `SyncRepository`, `PendingActionStore`, `Dio`).
2. Читает все `pending` `coordinates`-записи.
3. Отправляет одним `POST /coordinates`.
4. При успехе удаляет записи; при ошибке увеличивает счётчик попыток (существующий механизм `markFailedAttempt`).

### 3. Инициализация и перезапуск

- При входе `/sync` запрашивается в `AuthViewModel`/`MainShell` и сохраняется через `SyncConfigService`.
- `BackgroundBootstrap.start()` читает сохранённый конфиг и запускает `LocationService` с актуальным `coordinatesPeriodSec`.
- При изменении конфига (например, при повторном `/sync`) сервис перезапускается.

### 4. Граничные случаи

- **Нет сети:** точка остаётся в `PendingActionStore`; следующий цикл или WorkManager повторит.
- **Пустая очередь:** `sendCoordinates` не вызывается (guard `if (points.isEmpty) return`).
- **Приложение убито:** `WorkManager` с периодом `syncPeriodSec` отправит накопленный батч.
- **Минимальный период WorkManager:** 15 мин платформой; `syncPeriodSec` ограничен `SyncConfig.minSyncPeriodSec = 900`.

## Компоненты и изменения

- `lib/core/background/location_service.dart`
  - `LocationTaskHandler._collect` дополняется отправкой батча.
- `lib/core/background/sync_service.dart`
  - `syncCallbackDispatcher` инициализирует DI.
  - `coordinates`-действия обрабатываются пакетно.
- `lib/core/background/background_bootstrap.dart`
  - Без изменений в интерфейсе; период уже передаётся из `SyncConfig`.
- `lib/config/service_locator.dart`
  - Убедиться, что `setupDependencies` может быть вызвана из isolate WorkManager.
- `lib/data/services/pending_action_store.dart`
  - Добавить метод удаления списка записей после успешной отправки (если отсутствует).
- `lib/data/repositories/sync_repository_impl.dart`
  - Без изменений; `sendCoordinates(List<GeoPoint>)` уже принимает список.

## Тестирование

- `test/sync_repository_test.dart` (новый):
  - `sendCoordinates` отправляет `POST /coordinates` с массивом `GeoPoint.toJson()`.
  - Пустой список не вызывает запрос.
- `test/pending_action_store_test.dart` (расширить `services_test.dart`):
  - `enqueue`/`readPending` для `coordinates`.
  - Удаление отправленных записей.
- `test/location_task_handler_test.dart` (новый или mock-виджет):
  - `onRepeatEvent` собирает точку, кладёт в очередь и вызывает `sendCoordinates`.

## Не вошло в скоуп

- Изменение UI.
- Изменение формата `GeoPoint.toJson()`.
- Переход на чисто WorkManager-отправку (оставляем foreground как основной канал).
