import 'package:flutter/material.dart';

/// Фирменная палитра «Умная Логистика» по брендбуку.
///
/// HEX-коды подтверждены векторными заливками брендбука:
/// основной оранжевый, графит, синий, серая шкала.
class BrandColors {
  BrandColors._();

  /// Основной фирменный цвет — оранжевый (Pantone 1655 C).
  static const Color primary = Color(0xFFFE4500);

  /// Градиенты оранжевого для инфографики/акцентов.
  static const Color primaryLight1 = Color(0xFFFE6A33);
  static const Color primaryLight2 = Color(0xFFFE8F66);

  /// Тёмно-оранжевый для текста ссылок на светлом фоне (WCAG AA).
  static const Color primaryText = Color(0xFFD63A00);

  /// Тёмный графит — текст, фон (Pantone 426 C).
  static const Color graphite = Color(0xFF25252A);

  /// Синий акцент (Pantone 2727 C).
  static const Color blue = Color(0xFF337FFF);

  /// Зелёный — только для экранов (web/app).
  static const Color greenWeb = Color(0xFF00F55F);

  // Серая шкала — образована от основных цветов.
  static const Color grayDark = Color(0xFF57575C);
  static const Color grayMid = Color(0xFF888B8F);
  static const Color gray = Color(0xFFB2B7BC); // Cool Gray 5 C
  static const Color grayLight = Color(0xFFCBD0D6);
  static const Color grayLighter = Color(0xFFDAE0E5);

  /// Белый фон.
  static const Color white = Color(0xFFFFFFFF);

  /// Тёплый «бумажный» фон макетов.
  static const Color paperWarm = Color(0xFFFFFCF7);

  /// Цвет-заполнитель/placeholder текста.
  static const Color placeholder = grayMid;

  /// Цвет ошибок/деструктивных действий.
  static const Color error = Color(0xFFD32F2F);

  /// Цвет текста ошибок (на светлом фоне баннера).
  static const Color errorText = error;

  // --- Оттенки для чипов статусов заявок ---

  static const Color statusNewBackground = Color(0xFFE8F0FF);
  static const Color statusNewForeground = Color(0xFF1A5FCC);

  static const Color statusInProgressBackground = Color(0xFFFFF0E8);
  static const Color statusInProgressForeground = Color(0xFFC43000);

  static const Color statusRejectedBackground = Color(0xFFFFEBEE);
  static const Color statusRejectedForeground = Color(0xFFB71C1C);

  static const Color statusCompletedBackground = Color(0xFFDDFBE8);
  static const Color statusCompletedForeground = Color(0xFF0A6B2F);

  // --- Фоны баннеров состояний ---

  static const Color errorBackground = Color(0xFFFCE8E8);
  static const Color successBackground = Color(0xFFE0F7E9);
}
