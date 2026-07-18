# SmartTracker / Умный Водитель

Файл для AI-агентов, работающих с проектом. Здесь собрана актуальная информация об архитектуре, сборке, тестировании и соглашениях.

## 1. Обзор проекта

- **Название:** `smarttracker` (пакет `smarttracker`).
- **Продукт:** «Умный Водитель» — рабочий инструмент водителя логистической платформы «Умная логистика».
- **Платформы:** Flutter-приложение для Android и iOS.
- **Android applicationId:** `com.b2blogist.smarttracker`.
- **Android label:** `Умный Водитель`.
- **Язык интерфейса и комментариев:** русский, фиксированная локаль `Locale('ru', 'RU')`.
- **Базовый URL API:** `https://st.b2b-logist.com/api/`.
- **Основной документ:** см. `project-overview.md` — подробное описание экранов, API и бизнес-процессов.

## 2. Технологический стек

- **Flutter / Dart:** Flutter 3.27, Dart 3.6, SDK `>=3.6.0 <4.0.0`, канал `stable` (см. `.metadata`).
- **Архитектура:** MVVM: `ViewModel` (ChangeNotifier) + `Repository` + доменные модели.
- **DI:** `get_it` — глобальный контейнер `getIt` в `lib/config/service_locator.dart`.
- **Навигация:** `go_router` + `StatefulShellRoute.indexedStack` для нижней навигации.
- **Сетевой слой:** `dio` с перехватчиками (`AuthInterceptor`, `ErrorInterceptor`).
- **Модели данных:** `freezed` + `json_serializable`; сгенерированные файлы `*.g.dart` и `*.freezed.dart` исключены из анализа.
- **Безопасное хранение:** `flutter_secure_storage` (токен сессии).
- **Локальная БД:** `sqflite` — таблица `pending_actions` для офлайн-очереди.
- **Геолокация:** `geolocator` + `flutter_foreground_task` (foreground-сервис).
- **Фоновая синхронизация:** `workmanager`.
- **Push-уведомления:** `firebase_core`, `firebase_messaging`, `flutter_local_notifications`.
- **Фото:** `image_picker`, `path_provider`, `path`.
- **UI:** Material 3, брендовая тема, шрифты через `google_fonts` (Montserrat), иконки через `flutter_launcher_icons`.

## 3. Структура кода

```
lib/
├── config/               # AppConfig, DI (get_it), шины обновлений
├── core/background/      # Фоновые сервисы: геолокация, синхронизация, push
├── data/
│   ├── mappers/          # Маппинг API-моделей → доменные
│   ├── models/           # DTO/запросы/ответы (freezed)
│   ├── repositories/     # Реализации репозиториев + mock-реализации
│   └── services/         # Dio, перехватчики, secure storage, SQLite, города, настройки
├── domain/
│   ├── models/           # Чистые доменные модели и исключения
│   ├── repositories/     # Абстрактные интерфейсы репозиториев
│   └── use_cases/        # (зарезервировано)
├── ui/
│   ├── core/             # Тема, палитра, типографика, общие виджеты
│   └── features/         # Экраны по фичам: auth, location, main, orders, photos, notifications, profile
├── main.dart             # Точка входа, инициализация DI, фоновых сервисов, проверка сессии
└── router.dart           # Все маршруты go_router и редиректы
```

## 4. Ключевые конфигурационные файлы

- `pubspec.yaml` — зависимости, версия, assets, конфигурация иконок.
- `analysis_options.yaml` — `flutter_lints`, исключение сгенерированных файлов, `invalid_annotation_target: ignore`.
- `android/app/build.gradle` — `applicationId`, `minSdk = 21`, Java/Kotlin JVM target 17, плагин `google-services`.
- `android/settings.gradle` — AGP 8.2.0, Kotlin 1.9.24, Flutter Gradle Plugin 1.0.0.
- `android/gradle/wrapper/gradle-wrapper.properties` — Gradle 8.5.
- `android/app/src/main/AndroidManifest.xml` — разрешения (INTERNET, геолокация, foreground service, уведомления, RECEIVE_BOOT_COMPLETED).
- `android/build.gradle` — репозитории google/mavenCentral.
- `openapi.yaml` — OpenAPI-спецификация backend API.
- `project-overview.md` — детальное описание бизнес-логики.
- `google-services.json` — Firebase-конфигурация Android (файлы лежат в корне и в `android/app/`); **не должен попадать в публичный репозиторий**.

## 5. Сборка и запуск

Требуется установленный Flutter SDK. В данном окружении Flutter не найден в `PATH`, поэтому команды ниже нужно выполнять в окружении с Flutter.

```bash
# Установка зависимостей
flutter pub get

# Генерация freezed/json_serializable файлов (после изменений в data/models/)
flutter pub run build_runner build --delete-conflicting-outputs

# Запуск в debug-режиме
flutter run

# Сборка release APK
flutter build apk --release
# Артефакт: build/app/outputs/flutter-apk/app-release.apk
```

**Mock-режим:** в `lib/main.dart` замените `const config = AppConfig.production;` на `const config = AppConfig.mock;` — приложение будет работать без backend через `Mock*Repository`.

## 6. Тестирование

Тесты находятся в `test/`:

- `auth_view_model_test.dart` — доменная модель `User` и `AuthViewModel`.
- `geo_and_city_test.dart` — `GeoPoint.toJson` и `CityLookup`.
- `orders_view_model_test.dart` — `OrderMapper`, `OrderStatus`, `OrdersViewModel`.

Запуск:

```bash
flutter test
flutter analyze
```

В тестах используются лёгкие `Fake*`/`Mock*` репозитории. Виджет-тестов нет.

## 7. Архитектурные соглашения

- **MVVM:** `View` (Screen) слушает `ViewModel` (ChangeNotifier); `ViewModel` держит состояние и вызывает `Repository`.
- **Repository Pattern:** интерфейсы в `domain/repositories/`, реализации в `data/repositories/`. Есть mock-реализации для отладки.
- **DI:** все зависимости регистрируются в `setupDependencies`. Синглтоны: `AuthViewModel`, `LocationPermissionViewModel`, `UnreadBadgeViewModel`. Фабрики: `OrdersViewModel`, `OrderDetailViewModel`, `PhotoViewModel`, `ProfileViewModel`, `NotificationsViewModel`.
- **Модели:** DTO в `data/models/` генерируются через `freezed`/`json_serializable`. Доменные модели в `domain/models/` — обычные `class` с `const` конструкторами.
- **Ошибки:** `ErrorInterceptor` превращает Dio-ошибки в `AppException`: `NetworkException`, `ValidationException`, `ServerException`, `UnauthorizedException`, `UnknownException`.
- **Навигация:** маршруты объявлены в `lib/router.dart`. Редиректы зависят от `AuthStatus` и статуса разрешения геолокации.
- **Обновление списков:** `OrdersRefreshBus` и `NotificationsRefreshBus` (ChangeNotifier) используются для триггера перезагрузки из других фич.

## 8. Главные модули

### Авторизация (`lib/ui/features/auth/`)

- `AuthViewModel` — глобальное состояние сессии.
- `AuthStepperViewModel` — 4-шаговый флоу регистрации/восстановления пароля.
- Паспорт = 10 цифр, телефон = +7 (10 цифр), минимальная длина пароля = 6.
- Токен сохраняется в `flutter_secure_storage`; `AuthInterceptor` подставляет `Authorization: Bearer <token>`.

### Заявки (`lib/ui/features/orders/`)

- `OrdersViewModel` — три вкладки: «Новые» (status 1), «В работе» (2 и 5), «Архив» (`/orders/history`).
- `OrderDetailViewModel` — детали заявки, доступные действия по статусу, смена статуса.
- Статусы: 1 — Новая, 2 — В работе, 3 — Отказ, 4 — Завершена, 5 — Погружен.

### Фото (`lib/ui/features/photos/`)

- `PhotoViewModel` загружает/удаляет фото через `PhotoRepository`.
- Фото сохраняются в `ApplicationDocuments/photos` после выбора из галереи/камеры.
- Экран фото доступен только для заявок, принятых в работу.

### Уведомления (`lib/ui/features/notifications/`)

- `NotificationsViewModel` — список уведомлений, оптимистичное `markAsRead` с undo.
- `UnreadBadgeViewModel` — счётчик непрочитанных для нижней навигации.
- FCM data-only сообщения парсятся в `PushService`; при тапе открывается заявка по `order_id`.
- Локальный переключатель push: `SettingsService` + `shared_preferences`.

### Профиль (`lib/ui/features/profile/`)

- `ProfileViewModel` — загрузка, редактирование, смена пароля, аватар.
- После обновления профиля `AuthViewModel.updateUser` синхронизирует глобальное состояние.

### Геолокация и фон (`lib/core/background/`)

- `LocationService` — foreground-сервис, собирает координаты и кладёт в `PendingActionStore`.
- `CityLookup` — офлайн-поиск ближайшего города по `assets/cities/cities.csv`.
- `SyncService` — `workmanager`, периодически отправляет накопленные действия (`statusChange`, `photoUpload`, `coordinates`).
- `PendingActionStore` — SQLite; после 5 неудачных попыток действие помечается `failed`.
- Фоновые сервисы стартуют только при одновременном условии: пользователь аутентифицирован И разрешение геолокации = «Всегда».

## 9. Стиль кода и линты

- Подключён набор линтов `package:flutter_lints/flutter.yaml`.
- `avoid_print` не отключён, но и не включён принудительно.
- `prefer_single_quotes` не включён.
- Сгенерированные `**/*.g.dart` и `**/*.freezed.dart` исключены из анализа.
- `invalid_annotation_target: ignore` — ложное срабатывание на `@JsonKey` от freezed.
- Комментарии и пользовательские сообщения — на русском языке.
- Именование в `camelCase` для Dart-кода; константы брендовой палитры в `BrandColors`.

## 10. Безопасность

- Токен сессии хранится в `flutter_secure_storage` (v10): на Android используется шифрование по умолчанию (`EncryptedSharedPreferences`/`Keystore` в зависимости от версии плагина), на iOS — Keychain.
- Bearer-токен не добавляется к публичным auth-эндпоинтам (`/login`, `/registration`, `/restore`, `/user/send_phone_code`, `/user/send_restoring_phone_code`, `/user/verify_phone_code`).
- При ответе 401/403 `AuthInterceptor` очищает токен; роутер перенаправляет на экран входа.
- Разрешение на геолокацию должно быть «Всегда» для работы foreground-сервиса.
- `google-services.json` содержит Firebase-ключи; файлы есть в корне проекта и в `android/app/`. Они не должны коммититься в публичный репозиторий — проверьте `.gitignore` перед публикацией.
- FCM-токен отправляется на backend через `PUT /user/notification`.

## 11. Деплой

- Release-сборка Android подписывается debug-ключом (см. `android/app/build.gradle` `signingConfig = signingConfigs.debug`) — **перед публикацией нужно настроить собственный signing config**.
- Иконки приложения генерируются `flutter_launcher_icons`: исходники в `icons/`, адаптивная иконка Android на оранжевом фоне `#FE4500`.
- Для iOS требуется добавить `GoogleService-Info.plist` и разрешения на геолокацию/уведомления в `ios/Runner/Info.plist`.
- Минимальная Android-версия: `minSdk 21` (требование `flutter_secure_storage`).
- Сборочный стек: Flutter 3.27, Dart 3.6, AGP 8.2.0, Gradle 8.5, Kotlin 1.9.24, Java / Kotlin JVM target 17.

## 12. Что стоит помнить при изменениях

- После правок в `data/models/*.dart` запускайте `build_runner`.
- Если меняете интерфейс репозитория, обновите и mock-реализацию в `lib/data/repositories/mock_repositories.dart`.
- `AuthViewModel` и `LocationPermissionViewModel` — синглтоны; изменения состояния влияют на роутер и `MainShell`.
- Фоновые сервисы зависят от обоих синглтонов выше; тестируйте их совместное состояние.
- При добавлении новых публичных auth-эндпоинтов обновите множество `_publicAuthPaths` в `lib/data/services/auth_interceptor.dart`.

## 13. Design Context

Для работы с UI привязаны стратегический и визуальный контекст:

- `PRODUCT.md` — регистр (`product`), платформа (`adaptive`), пользователи, позиционирование, личность бренда и антиреференсы.
- `DESIGN.md` — дизайн-система: палитра, типографика, радиусы, компоненты, правила высоты и Do's/Don'ts.
- `.impeccable/design.json` — машиночитаемый sidecar с тональными шкалами, CSS/HTML-сниппетами компонентов и narrative для панели Stitch.

Ключевые принципы при изменениях UI:

- **Регистр — product, платформа — adaptive.** Дизайн служит рабочему процессу водителя, не маркетингу. Используем Material 3 как базу, но проверяем решения под две платформы.
- **Один акцент.** Signal Orange (`#FE4500`) — единственный брендовый акцент. Синий, зелёный и красный зарезервированы для семантики статусов.
- **Плоские поверхности.** Карточки и контейнеры используют 1px-рамку `gray-lighter`, а не тени. Тени только у нижней навигации.
- **Типографика.** Montserrat для всего UI, Bebas Neue — для дисплейных заголовков.
- **Радиусы.** 12px для кнопок, карточек, полей; pill (`999px`) — только для чипов и бейджей.
- **Доступность.** Целевой уровень WCAG 2.1 AA, поддержка `prefers-reduced-motion`, статусы не зависят только от цвета.
- **Язык интерфейса.** Русский, фиксированная локаль `Locale('ru', 'RU')`.
