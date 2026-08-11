# Публикация в App Store — чеклист и готовые ответы

Сводный документ по iOS-сабмиту «Умный Водитель». Технические правки
(PrivacyInfo.xcprivacy, entitlements, подпись, AppDelegate, Info.plist) уже в
коде — здесь только то, что заполняется руками в App Store Connect и
проверяется перед архивацией.

## 1. App Privacy «nutrition label» (App Store Connect → App Privacy)

Ответы ниже синхронизированы с `ios/Runner/PrivacyInfo.xcprivacy`. Если менять
здесь — менять и там, и наоборот.

**Общие вопросы:**
- **Собирает ли приложение данные?** — `Да`
- **Используются ли данные для отслеживания (Tracking)?** — `Нет` (ATT не запрашивается, рекламных/аналитических SDK нет)

**Декларируемые типы данных** (для каждого: Linked to identity = `Да`, Used for tracking = `Нет`, Purpose = `App Functionality`):

| Тип данных | Purpose | Почему собирается |
|---|---|---|
| Location (Precise) | App Functionality | Геолокация водителя передаётся диспетчеру, в т.ч. в фоне при активной заявке |
| Photos or Videos | App Functionality | Фото груза и документов по заявкам |
| Phone Number | App Functionality | Идентификация водителя при регистрации/входе |
| User ID | App Functionality | Токен авторизации (хранится в secure storage, передаётся как Bearer) |
| Device ID | App Functionality | FCM-токен для доставки push-уведомлений |

**Типы данных, которые НЕ собираются** (отметить `Нет` / не добавлять):
Coarse Location, Email, Name, Physical Address, Other User Contact Info, Financial
Info, Health, Fitness, Audio Data, Game Data, Customer Support, Browsing History,
Search History, Usage Data, Product Interaction, Crash Data, Performance Data,
Diagnostics, Advertising Data, Sensitive Info.

**Доп. вопросы раздела:**
- **Все ли типы используются для сторонней рекламы/маркетинга?** — `Нет`
- **Отправляются ли данные третьим лицам?** — определить по договору с ООО «Умная Логистика» (координаты передаются на backend b2b-logist.com). Если считается «sharing» — указать Purpose = App Functionality и что получатель — ООО «Умная Логистика» как обработчик.

## 2. Содержимое Privacy Policy (ручной обзор)

URL `https://cargo.b2b-logist.com/upload/user_policy_personal_data.pdf` публично
доступен (проверено — отдаёт PDF без авторизации). Перед сабмитом убедиться, что
документ покрывает:

- [ ] Сбор **точного местоположения**, в т.ч. **фонового** (пока заявка в работе)
- [ ] Сбор **фотографий** груза/документов
- [ ] Сбор **номера телефона** и идентификационных данных (паспорт/код)
- [ ] **Идентификаторы устройства** (FCM-токен для push)
- [ ] Где и как хранятся данные (secure storage на устройстве, backend ООО «Умная Логистика»)
- [ ] **Право пользователя запросить удаление данных** — критично для Apple Guideline 5.1.1(v); пока в приложении нет функции удаления аккаунта (см. п. 5 ниже), в политике должен быть хотя бы контакт для запроса удаления
- [ ] Сроки хранения и получатели (ООО «Умная Логистика» как оператор)

Если каких-то пунктов нет — согласовать с юристом обновление PDF до сабмита.

## 3. Перед архивацией (фикс версионного дрифта)

`pubspec.yaml` → `version: 2.0.0+2`, но `ios/Flutter/Generated.xcconfig`
регенерируется только при `flutter pub get` / `flutter build`. Если архивировать
в Xcode без этого шага — в App Store Connect уйдёт версия `1.0.0 (1)`.

**Перед каждым iOS-архивом выполнять строго в таком порядке:**

```bash
flutter pub get                                  # регенерирует Generated.xcconfig
flutter build ios --release --no-codesign        # прогон кодогена
# затем в Xcode: Product → Archive
```

Для CI / `xcodebuild -exportArchive` использовать `ios/Runner/ExportOptions.plist`
(Team `UT5J665DV8`, `signingStyle=automatic`, `method=app-store`).

## 4. Toolchain — Xcode 26 / iOS 26 SDK

С 28 апреля 2026 Apple требует загрузки собирать на **Xcode 26** с SDK iOS 26.
Сейчас `LastUpgradeCheck = 1510` (Xcode 15.1). Перед публикацией обновить
toolchain на сборочной macOS-машине (`.flutter_sdk` для Android-сборок не
используется при iOS-архивации — там нужен системный Xcode).

## 5. Удаление аккаунта (блокер, отложено)

Guideline 5.1.1(v): приложение с регистрацией обязано позволять удалить аккаунт
из самого приложения. Сейчас в коде есть только «Выйти из аккаунта» — это не
удаление. Реализация отложена до готовности backend-эндпоинта. **До реализации
Apple ревью не пройдёт** — либо реализовать до сабмита, либо (временный обход)
дать в приложении ссылку/кнопку на веб-форму запроса удаления, которая реально
инициирует удаление данных (не просто деактивацию).

## 6. Прочее (низкий приоритет)

- **Launch Screen** — сейчас stock-шаблон (белый фон, центрированный LaunchImage). Брендовый лонч-скрин (логотип на фирменном фоне) — нужен дизайн-ассет; в `icons/` есть `ic_launcher.png` и `ul_logo_black.png` как кандидаты.
- **iPad** — решено оставить универсальным (`TARGETED_DEVICE_FAMILY = "1,2"`, портрет только). **Перед сабмитом обязательно** протестировать UI на реальном iPad (включая сплит-режим), иначе риск замечаний по дизайну (Apple 4.0 Design). Если-layout на iPad окажется неприемлемым — переключить на `TARGETED_DEVICE_FAMILY = 1` (только iPhone).
- **ATS / dev-сервер** — добавлено узкое ATS-исключение для `st-dev.b2b-logist.com` (cleartext HTTP для dev-сборок; production на HTTPS идёт по строгим правилам). При ревью Apple может спросить про ATS-исключение — ответ: «внутренний dev-сервер для тестирования, production-сборка его не использует».
