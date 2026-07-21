# Аудит готовности к публикации в Google Play

Дата аудита: 2026-07-20
Платформа: Android (`com.b2blogist.smarttracker`)
Flavor публикации: `prod`

---

## ✅ Что соответствует требованиям

| Параметр | Значение | Статус |
|---|---|---|
| `applicationId` | `com.b2blogist.smarttracker` | ✓ |
| `versionCode` / `versionName` | `1` / `1.0.0` | ✓ |
| `minSdkVersion` | 24 (системно; в AGENTS.md указано 23, но фактически Flutter ставит 24) | ✓ (≥ 23) |
| `targetSdkVersion` | 36 | ✓ (актуальная, Google требует ≥ 34 для новых приложений с 2024) |
| `compileSdk` | 36 | ✓ |
| Иконка приложения | адаптивная `BW.xml` на всех плотностях | ✓ |
| Label | «Умный Водитель» | ✓ |
| HTTPS-only в prod | да (cleartext только в dev-флаворе) | ✓ |
| Single launchable activity | `MainActivity` с корректным `intent-filter` | ✓ |
| `flutterEmbedding` v2 | да | ✓ |
| User Agreement в app | есть (`/auth/agreement`, `assets/legal/user_agreement.md`) | ✓ |
| Privacy Policy в app | ссылка ведёт наружу (`LegalLinks.privacyPolicy`) | ⚠️ см. ниже |

---

## 🚨 Критические проблемы (блокируют публикацию)

### 1. **Release-сборка подписана debug-ключом**
```gradle
signingConfig = signingConfigs.debug  // ← блокировка
```
Google Play **не примет** APK/AAB, подписанный debug-keystore. Нужен собственный release-keystore.

**Что нужно сделать:**
```bash
keytool -genkey -v -keystore smarttracker.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias smarttracker
```
Затем добавить `signingConfigs.release` в `android/app/build.gradle` и вынести пароли в `key.properties` (не коммитить!).

### 2. **Загружать нужно AAB, а не APK**
Начиная с августа 2021 Google Play требует формат **Android App Bundle** (`.aab`) для новых приложений.

```bash
flutter build appbundle --release --flavor prod --no-tree-shake-icons
# Артефакт: build/app/outputs/bundle/prodRelease/app-prod-release.aab
```

> ⚠️ **Флаг `--no-tree-shake-icons` обязателен** для всех сборок (APK и AAB, dev и prod).
> Без него Flutter вырезает «неиспользуемые» иконки Material/Cupertino на этапе компиляции,
> но часть из них на самом деле нужна в runtime (например, иконки со ссылкой через переменную).
> Это приводило к пропаданию иконок в собранной сборке.

### 3. **Отсутствует Privacy Policy в виде публичного URL**
В `_AgreementConsent` ссылка `LegalLinks.privacyPolicy` ведёт наружу. Google Play Console в списке приложений требует **публично доступный URL** Privacy Policy, и приложение должно содержать пункт меню с ссылкой на неё.
- В коде ссылка есть ✓
- Нужно создать веб-страницу (например, на сайте компании) и убедиться, что URL из `LegalLinks.privacyPolicy` ведёт на неё.

### 4. **Foreground service + `ACCESS_BACKGROUND_LOCATION` → требует Data Safety Form**
Это самая строгая категория в Google Play. Объявлены:
- `ACCESS_BACKGROUND_LOCATION`
- `FOREGROUND_SERVICE_LOCATION`
- `foregroundServiceType="location"`

Триггерится политика **Location Permissions** (действует с 2024):
- В Data Safety нужно указать: «Location → Approximate / Precise → Background»
- Дать ссылку на видео-демонстрацию работы фоновой геолокации (Google требует видео в 30+ секунд, где виден foreground notification и отзыв разрешения)
- Обосновать в консоли, зачем нужен background location
- Текст prominent disclosure (уже есть в `_DisclosureText`) — Google требует, чтобы в нём был **конкретный текст** про «даже когда приложение закрыто» (проверьте `LegalTexts.locationDisclosureEmphasis`).

---

## ⚠️ Серьёзные замечания

### 5. **`RECEIVE_BOOT_COMPLETED` — включён автозапуск после перезагрузки** ✅
Сервис геолокации настроен на автозапуск после перезагрузки устройства и после обновления приложения (`autoRunOnBoot: true`, `autoRunOnMyPackageReplaced: true` в `location_service.dart`). Разрешение `RECEIVE_BOOT_COMPLETED` объявлено в манифесте — **обосновать при ревью Google Play** (см. готовый текст ниже).

#### Обоснование для Google Play Console

**Где используется разрешение:**
> Разрешение `RECEIVE_BOOT_COMPLETED` используется исключительно для автоматического перезапуска foreground-сервиса передачи геолокации после перезагрузки устройства. Без него водители в активных логистических маршрутах теряли бы GPS-отслеживание после перезагрузки телефона, что нарушает основную функцию приложения водителя.

**Поле «Why does your app need to receive the BOOT_COMPLETED broadcast?» в Data Safety / Prominent Disclosure:**
> «Умный Водитель» — это рабочий инструмент водителя-логиста. Приложение передаёт координаты водителя диспетчеру в реальном времени через foreground-сервис геолокации (с видимым уведомлением «Передача геопозиции…»).
>
> Разрешение RECEIVE_BOOT_COMPLETED необходимо, чтобы foreground-сервис автоматически перезапускался после перезагрузки телефона. Без этого водителю пришлось бы вручную открывать приложение после каждой перезагрузки — в условиях рейса (телефон в кабине, на зарядке, не всегда в руках) это приводило бы к потере координат и нарушению бизнес-процесса доставки.
>
> Сервис запускается только если пользователь:
> 1. вошёл в приложение (прошёл аутентификацию);
> 2. выдал разрешение геолокации «Всегда» (background location).
>
> При выходе из аккаунта сервис останавливается, и автозапуск после перезагрузки не происходит.

#### Важно проверить при ревью
- `RebootReceiver` в merged-манифесте имеет `exported=true` — это нужно плагину для приёма системных broadcast'ов (BOOT_COMPLETED, MY_PACKAGE_REPLACED, QUICKBOOT_POWERON).
- На Android 12+ broadcast'ы BOOT_COMPLETED система шлёт только приложениям, которые были запущены пользователем хотя бы один раз — это безопасное поведение, не нарушает приватность.
- Сервис стартует только если был корректно остановлен разработчиком (`isCorrectlyStopped()`), иначе остаётся в прежнем состоянии.

### 6. **Нужно явно запросить разрешение уведомлений на Android 13+**
Сейчас `POST_NOTIFICATIONS` есть в манифесте, но запрос идёт только внутри `LocationService.start()` (через `FlutterForegroundTask.requestNotificationPermission()`). Это сработает, но Google рекомендует показывать запрос **до того**, как функция нужна. Лучше запросить в `PushService.init()` тоже — там уже идёт `FirebaseMessaging.instance.requestPermission()`, но он покрывает только FCM, а не локальные уведомления foreground-сервиса. Покрыто сейчас косвенно — проверьте на реальном устройстве.

### 7. **Targeting SDK 36 — требует `foregroundServiceType` со всеми типами**
Уже добавил в манифесте (`location`). Проверьте, что `FOREGROUND_SERVICE_LOCATION` разрешение присутствует — ✓ есть.

---

## ⚠️ Менее критичные замечания

### 8. **Не исключён `google-services.json` из публичной репозитории**
AGENTS.md прямо предупреждает: `google-services.json` не должен попадать в git. Проверьте `.gitignore`:
```bash
grep "google-services" .gitignore
```
Если файлов нет в `.gitignore`, Firebase-ключи уйдут в репозиторий. **Секреты Firebase не критичны сами по себе**, но Google Play scans AAB на наличие ключей и иногда ругается.

### 9. **`application-label` на всех языках одинаковый**
Все лейблы — «Умный Водитель», что нормально. Но в Google Play Console можно задать локализованные имена отдельно.

### 10. **App Bundle / 64-bit**
Flutter 3.44 по умолчанию собирает 64-bit нативные библиотеки. AAB автоматически разделяет по ABI, проблем не будет. Главное — собирать `appbundle`, а не `apk`.

### 11. **Описания для Data Safety Form**
Нужно заполнить анкету Data Safety в Play Console (обязательно для всех приложений с 2023):
- **Location** (precise + background) — для foreground-сервиса
- **Personal info** (имя, телефон, паспорт) — для регистрации
- **Photos** — для фото по заявке
- **Device ID** (FCM token) — для push

### 12. **Target audience**
В Play Console выберите 18+ (или проверьте, что нет контента для детей — у вас приложение для водителей логистики, вопросов быть не должно).

---

## 📋 Чек-лист перед публикацией

1. ✅ ~~Сгенерировать release-keystore и настроить `signingConfigs.release`~~ — готово (`android/app/smarttracker.jks`, `android/key.properties`)
2. ☐ Собрать `.aab` (а не `.apk`) и подписать release-ключом — команда готова, собирается успешно
3. ☐ Опубликовать Privacy Policy на публичном URL
4. ☐ Записать видео-демонстрацию фоновой геолокации (для Location Permission policy)
5. ☐ Заполнить Data Safety Form в Play Console
6. ☐ Подготовить иконку 512×512 (feature graphic) и 1024×500 для листинга
7. ☐ Подготовить 2–3 скриншота для листинга (минимум)
8. ✅ ~~Проверить, что `google-services.json` в `.gitignore`~~ — готово (покрыты все flavor'ы)
9. ✅ ~~Определиться с `RECEIVE_BOOT_COMPLETED`~~ — готово: автозапуск включён, обоснование выше
10. ☐ Указать контактный email для разработчика

---

## 🎯 Приоритеты для технических правок кода

Можно сделать автоматически:
1. **Настроить release signing config** в `build.gradle` (с `key.properties`)
2. **Собрать AAB** вместо APK
3. **Проверить/обновить `.gitignore`** для `google-services.json`
4. **Удалить лишнее `RECEIVE_BOOT_COMPLETED`** или включить `autoRunOnBoot`

Остальные пункты (Privacy Policy URL, видео, Data Safety Form, keystore-пароль) требуют решений вне кода.
