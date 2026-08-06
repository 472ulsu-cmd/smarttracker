# Аудит готовности к публикации в Google Play

Дата актуализации: 2026-08-06  
Платформа: Android  
Production applicationId: `com.b2blogist.smarttracker`  
Публикационный flavor: `prod`  
Тестовый flavor: `dev`

---

## Краткий вывод

Функциональная проверка основных пользовательских сценариев пройдена успешно. Release-keystore подготовлен и production AAB подписан собственным сертификатом `CN=SmartTracker, O=B2B-Logist` (не debug). Публикация в Google Play пока не готова из-за Privacy Policy URL, требований к фоновой геолокации и материалов листинга.

В актуальном прогоне собраны и проверены dev/prod APK; production AAB собран, подпись проверена через `keytool`/`jarsigner`. Тесты и analyze зелёные.

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
| Release-подпись | `android/key.properties` + `android/app/smarttracker.jks` присутствуют; AAB подписан `CN=SmartTracker, O=B2B-Logist` | ✅ |

## Результаты фактического тестирования

### Среда и сборка

- Flutter 3.44.6, Dart 3.12.2.
- Эмулятор Android 35 (`smarttracker-api35`), API 35, x86_64.
- Dev APK собран с `--flavor dev --no-tree-shake-icons` и установлен на эмулятор.
- Артефакт: `build/app/outputs/flutter-apk/app-dev-release.apk`.
- Production AAB: `build/app/outputs/bundle/prodRelease/app-prod-release.aab` (≈58.1 MB), подписан release-сертификатом `CN=SmartTracker, O=B2B-Logist` (см. «Устранённые блокеры»).
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

## ✅ Блокеры публикации — устранённые

### 1. Release-подпись подготовлена

В `android/app/build.gradle` есть `signingConfigs.release`, параметры которого берутся из `android/key.properties`. При отсутствии файла release-сборка откатывается на debug-подпись:

```gradle
signingConfig = keystorePropertiesFile.exists()
        ? signingConfigs.release
        : signingConfigs.debug
```

В рабочей копии присутствуют и `android/key.properties`, и `android/app/smarttracker.jks` (оба исключены из git). Таким образом, release-сборка подписывается собственным ключом.

`key.properties`, `*.jks` и `*.keystore` исключены из git.

### 2. Production AAB подписан release-ключом

AAB собран: `build/app/outputs/bundle/prodRelease/app-prod-release.aab` (≈58.1 MB). Проверка `keytool -printcert`/`jarsigner` подтверждает собственный сертификат, **не** debug:

```text
Owner: CN=SmartTracker, OU=Mobile, O=B2B-Logist, L=Moscow, ST=Moscow, C=RU
Valid from: Mon Jul 20 17:28:55 MSK 2026 until: Fri Dec 05 17:28:55 MSK 2053
SHA1:   E8:83:FC:B9:BD:48:A3:3A:CB:0F:3B:7D:2E:B9:37:9C:A5:61:0A:B9
SHA256: 9A:9C:06:80:AE:71:C2:A3:F1:9C:B8:17:11:03:4B:F6:C7:E5:37:68:10:40:13:58:E6:C4:ED:97:0E:69:08:47
```

> Примечание: предыдущий прогон аудита (2026-08-05) ошибочно зафиксировал подпись `CN=Android Debug` — фактически keystore уже был создан 2026-07-20, и проверенная в этом прогоне подпись принадлежит release-сертификату. Перед публикацией AAB следует пересобрать заново, чтобы артефакт отражал последний код.

Для публикации используйте:

```bash
flutter build appbundle --release --flavor prod --no-tree-shake-icons
```

Ожидаемый артефакт:

```text
build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

Флаг `--no-tree-shake-icons` обязателен для текущего проекта: без него часть Material/Cupertino-иконок может отсутствовать в runtime.

## 🚨 Блокеры публикации

### 1. Privacy Policy должна быть доступна по публичному URL

В приложении предусмотрена ссылка `LegalLinks.privacyPolicy`, но публичная доступность и содержимое страницы в рамках этого прогона не проверялись. До публикации нужно:

- проверить URL без авторизации;
- убедиться, что страница содержит актуальную политику конфиденциальности;
- указать тот же URL в Google Play Console и в приложении.

### 2. Background location требует заполнения Play Console

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

`google-services.json` для flavor'ов `prod`/`dev` и корневой `google-services.json` исключены из будущих коммитов через `.gitignore`.

> ⚠️ Однако в репозитории всё ещё **отслеживается** `google-services-dev.json` в корне проекта. В файле присутствует Firebase API key (`AIza…`) и идентификаторы проекта (`smarttracker-e9986`). Файл нужно убрать из git (`git rm --cached google-services-dev.json`, добавить в `.gitignore`), а ключ — ротировать в Firebase Console, так как он уже в истории. Продакшен-файлы (`android/app/src/prod/google-services.json`, `android/app/src/dev/google-services.json`) в git отсутствуют — это корректно.

### Data Safety

В Play Console потребуется отразить фактическую обработку данных:

- точная и фоновая геолокация;
- персональные данные водителя: имя, телефон, паспортные данные;
- фотографии по заявкам;
- device/FCM token для push-уведомлений.

### Материалы листинга

Нужно подготовить описание приложения, иконку/feature graphic, минимум 2–3 скриншота, возрастную категорию и контактный email разработчика.

## 📋 Чек-лист перед публикацией

1. ✅ Создать release-keystore и `android/key.properties`.
2. ✅ Убедиться, что production не откатывается на debug-подпись — AAB подписан `CN=SmartTracker, O=B2B-Logist`.
3. ✅ Собрать production `.aab` с `--no-tree-shake-icons` — собран и подписан; перед публикацией пересобрать свежий артефакт.
4. ✅ Проверить подпись; установить production-сборку на тестовое устройство — подпись проверена, установка на эмулятор подтверждена ранее.
5. ☐ Опубликовать и проверить Privacy Policy по публичному URL.
6. ☐ Заполнить Data Safety Form и пройти требования Location Permission policy.
7. ☐ Записать видео работы фоновой геолокации.
8. ✅ Проверить перезагрузку устройства и автозапуск foreground-сервиса — подтверждено на эмуляторе Android 35; физическое устройство не проверено.
9. ☑ Проверить просмотр загруженного фото — подтверждено на эмуляторе; повторить FCM-тесты на физическом устройстве.
10. ⚠️ Проверить `.gitignore` для Firebase-конфигурации и ключей — правила есть, но `google-services-dev.json` (с API key) всё ещё отслеживается в git; убрать и ротировать ключ.
11. ☐ Подготовить материалы листинга и указать контактный email.

## Итоговый статус

Приложение функционально тестируемо и основные сценарии работают. Release-keystore подготовлен, production AAB подписан собственным сертификатом `CN=SmartTracker, O=B2B-Logist`. Статус готовности к публикации: **не готово** — остаются публикация/проверка Privacy Policy URL, оформление фоновой геолокации в Google Play Console (Data Safety, prominent disclosure, видео), удаление из git и ротация утёкшего Firebase-ключа, а также физические проверки и материалы листинга. Перед публикацией AAB следует пересобрать свежим.