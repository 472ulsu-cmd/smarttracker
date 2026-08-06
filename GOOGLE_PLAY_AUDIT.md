# Аудит готовности к публикации в Google Play

Дата актуализации: 2026-08-05  
Платформа: Android  
Production applicationId: `com.b2blogist.smarttracker`  
Публикационный flavor: `prod`  
Тестовый flavor: `dev`

---

## Краткий вывод

Функциональная проверка основных пользовательских сценариев пройдена успешно. Production AAB собран и проверен; публикация в Google Play пока не готова из-за debug-подписи, Privacy Policy URL и требований к фоновой геолокации.

В актуальном прогоне собраны и проверены dev APK и production AAB. AAB подписан Android Debug и не готов к публикации до настройки release-keystore.

## Технические параметры

| Параметр | Фактическое значение | Статус |
|---|---|---|
| `applicationId` production | `com.b2blogist.smarttracker` | ✅ |
| `applicationId` dev | `com.b2blogist.smarttracker.develop` | ✅ |
| `versionCode` / `versionName` | `2` / `2.0.0` | ✅ |
| `minSdkVersion` | `24` | ✅ |
| `targetSdkVersion` | `36` | ✅ |
| `compileSdk` | `36` | ✅ |
| Label production | «Умный Водитель» | ✅ |
| HTTPS в production | да; cleartext разрешён только в dev | ✅ |
| Launchable activity | `MainActivity`, корректный `MAIN/LAUNCHER` | ✅ |
| Flutter embedding | v2 | ✅ |
| User Agreement | есть в приложении | ✅ |
| Privacy Policy | ссылка предусмотрена, публичный URL отдельно не подтверждён | ⚠️ |
| Release-подпись | в рабочей копии нет `android/key.properties` и keystore | 🚨 |

## Результаты фактического тестирования

### Среда и сборка

- Flutter 3.44.6, Dart 3.12.2.
- Эмулятор Android 35 (`smarttracker-api35`), API 35, x86_64.
- Dev APK собран с `--flavor dev --no-tree-shake-icons` и установлен на эмулятор.
- Артефакт: `build/app/outputs/flutter-apk/app-dev-release.apk`.
- Production AAB: `build/app/outputs/bundle/prodRelease/app-prod-release.aab` (58.1 MB).
- `flutter test`: **86/86 успешно**.
- `flutter analyze`: **No issues found!**.
- Фатальных ошибок и `E/flutter` в logcat во время прогона не обнаружено.

### Проверенные сценарии

- Авторизация тестовым пользователем и восстановление сессии после force-stop/relaunch.
- Вкладки заявок: новые, в работе, архив; поиск и открытие деталей.
- Жизненный цикл тестовой заявки №160: `Новая → В работе → Погружен → Завершена`.
- Загрузка фото по заявке; загруженное фото получило статус «На рассмотрении».
- Полноэкранный просмотр загруженного фото открыт после фикса hit-target; добавлен regression widget test.
- Уведомления и переход из уведомления в заявку; deep link открыл заявку №160.
- Профиль и сохранение данных без изменений.
- Пользовательское соглашение.
- Отправка обратной связи.
- Разрешения уведомлений и геолокации.
- Запуск foreground-сервиса геолокации; после перезапуска приложения сервис наблюдался активным.

### Исправленное функциональное замечание

В исходном прогоне tap по фото не открывал просмотрщик. Исправлен hit-target превью (`Semantics.onTap` + фиксированный размер + `InkWell`), добавлен `test/photo_thumbnail_test.dart`, viewer подтверждён на эмуляторе Android 35.

### Изменённые тестовые данные

- Заявка №160 переведена в статус «Завершена».
- В заявку №160 загружено тестовое изображение.
- Отправлена тестовая обратная связь `test_feedback_2026`.
- Одно уведомление отмечено прочитанным.

## 🚨 Блокеры публикации

### 1. Release-подпись не подготовлена

В `android/app/build.gradle` есть `signingConfigs.release`, но release-сборка использует debug-подпись, если отсутствует `android/key.properties`:

```gradle
signingConfig = keystorePropertiesFile.exists()
        ? signingConfigs.release
        : signingConfigs.debug
```

В рабочей копии отсутствуют `android/key.properties` и keystore. Google Play не принимает сборку, подписанную debug-keystore.

Что нужно сделать:

1. Создать собственный release-keystore.
2. Заполнить локальный `android/key.properties`.
3. Собрать production AAB.
4. Проверить сертификат и подпись собранного AAB.

`key.properties`, `*.jks` и `*.keystore` уже исключены из git.

### 2. Production AAB собран, но подписан debug-ключом

AAB собран: `build/app/outputs/bundle/prodRelease/app-prod-release.aab` (58.1 MB). Проверка `jarsigner` выявила сертификат `CN=Android Debug`, поэтому артефакт не является publishable release-сборкой. Нужны release-keystore и `android/key.properties`, после чего сборку следует повторить.

Для публикации используйте:

```bash
flutter build appbundle --release --flavor prod --no-tree-shake-icons
```

Ожидаемый артефакт:

```text
build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

Флаг `--no-tree-shake-icons` обязателен для текущего проекта: без него часть Material/Cupertino-иконок может отсутствовать в runtime.

### 3. Privacy Policy должна быть доступна по публичному URL

В приложении предусмотрена ссылка `LegalLinks.privacyPolicy`, но публичная доступность и содержимое страницы в рамках этого прогона не проверялись. До публикации нужно:

- проверить URL без авторизации;
- убедиться, что страница содержит актуальную политику конфиденциальности;
- указать тот же URL в Google Play Console и в приложении.

### 4. Background location требует заполнения Play Console

В production manifest объявлены:

- `ACCESS_FINE_LOCATION`;
- `ACCESS_COARSE_LOCATION`;
- `ACCESS_BACKGROUND_LOCATION`;
- `FOREGROUND_SERVICE_LOCATION`;
- `foregroundServiceType="location"`.

Нужно подготовить Data Safety Form, prominent disclosure, обоснование фоновой геолокации и видео демонстрации работы foreground-сервиса согласно требованиям Google Play.

## ⚠️ Замечания перед публикацией

### `RECEIVE_BOOT_COMPLETED`

В `location_service.dart` включены `autoRunOnBoot: true` и `autoRunOnMyPackageReplaced: true`, а разрешение объявлено в manifest. После полной перезагрузки эмулятора Android 35 receiver поднял сервис с `code:BOOT_COMPLETED`; `dumpsys` показал `isForeground=true`, `foregroundId=1000`. Запуск проявился с задержкой после `sys.boot_completed=1`; физическое устройство не проверялось. Для Play Console по-прежнему нужно подготовить обоснование разрешения.

### Уведомления Android 13+

Разрешение `POST_NOTIFICATIONS` присутствует и было выдано на эмуляторе. Foreground-уведомление отображалось, ошибок в logcat не обнаружено. Перед публикацией желательно повторить проверку на физическом Android 13+ и отдельно проверить FCM в foreground/background/terminated-состояниях.

### Firebase-конфигурация

`google-services.json` для flavor'ов исключён из будущих коммитов через `.gitignore`. Нужно дополнительно убедиться, что эти файлы не попали в публичную git-историю; при необходимости удалить их из истории и ротировать ключи Firebase.

### Data Safety

В Play Console потребуется отразить фактическую обработку данных:

- точная и фоновая геолокация;
- персональные данные водителя: имя, телефон, паспортные данные;
- фотографии по заявкам;
- device/FCM token для push-уведомлений.

### Материалы листинга

Нужно подготовить описание приложения, иконку/feature graphic, минимум 2–3 скриншота, возрастную категорию и контактный email разработчика.

## 📋 Чек-лист перед публикацией

1. ☐ Создать release-keystore и `android/key.properties`.
2. ☐ Убедиться, что production не откатывается на debug-подпись.
3. ✅ Собрать production `.aab` с `--no-tree-shake-icons` — собран; перед публикацией пересобрать после настройки release-keystore.
4. ☐ Проверить подпись и установить production-сборку на тестовое устройство.
5. ☐ Опубликовать и проверить Privacy Policy по публичному URL.
6. ☐ Заполнить Data Safety Form и пройти требования Location Permission policy.
7. ☐ Записать видео работы фоновой геолокации.
8. ✅ Проверить перезагрузку устройства и автозапуск foreground-сервиса — подтверждено на эмуляторе Android 35; физическое устройство не проверено.
9. ☑ Проверить просмотр загруженного фото — подтверждено на эмуляторе; повторить FCM-тесты на физическом устройстве.
10. ✅ Проверить `.gitignore` для Firebase-конфигурации и ключей.
11. ☐ Подготовить материалы листинга и указать контактный email.

## Итоговый статус

Приложение функционально тестируемо и основные сценарии работают. Production AAB собран, но подписан debug-ключом. Статус готовности к публикации: **не готово** до настройки release-подписи, публикации Privacy Policy URL и оформления фоновой геолокации в Google Play Console; физические проверки и материалы листинга также остаются.