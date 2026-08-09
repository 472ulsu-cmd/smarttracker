import 'package:flutter/material.dart';

/// Сквозные хелперы показа SnackBar с гарантированной доступностью.
///
/// Проблема: Flutter-`SnackBar` на iOS VoiceOver не объявляется как
/// live-region автоматически — слепой водитель не слышит ни ошибок, ни
/// подтверждений. Обёртка `content` в `Semantics(container: true,
/// liveRegion: true)` форсирует анонс на обеих платформах (на Android
/// TalkBack это не дублирует — он и так анонсирует SnackBar как единый
/// узел, а обёртка лишь уточняет label).
///
/// Тоновый префикс в semantics-label доводит до скринридера характер
/// сообщения («Ошибка.»), не искажая видимый текст.
///
/// Используйте [showErrorSnackBar] для провалов и ошибок валидации,
/// [showSuccessSnackBar] — для подтверждений действия. Внешний вид
/// (фон/текст/форма) берётся из `snackBarTheme` (`app_theme.dart`), поэтому
/// переопределять стили здесь не нужно.

/// Показывает SnackBar об ошибке.
///
/// [message] — видимый текст. К скринридеру он доносится с префиксом
/// «Ошибка.», чтобы тон был однозначен. [action] — необязательное действие
/// (например, «Настройки» для ошибки доступа).
void showErrorSnackBar(
  BuildContext context,
  String message, {
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Semantics(
        container: true,
        liveRegion: true,
        label: 'Ошибка. $message',
        child: Text(message),
      ),
      action: action,
    ),
  );
}

/// Показывает SnackBar об успешном действии (без префикса — сообщение
/// само по себе утвердительное: «Профиль сохранён», «Пароль изменён»).
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Semantics(
        container: true,
        liveRegion: true,
        child: Text(message),
      ),
    ),
  );
}
