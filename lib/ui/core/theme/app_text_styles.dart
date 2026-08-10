import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// Типографика приложения по брендбуку.
///
/// Основной шрифт — **Montserrat** (Regular/Medium/SemiBold/Bold).
/// Акцентный шрифт для крупных заголовков — **Bebas Neue** (Regular).
/// Шрифты bundled в assets/fonts (OFL), сеть не требуется.
/// Внимание: Bebas Neue не содержит кириллицу — русские глифы
/// отрисуются системным fallback-шрифтом.
class AppTextStyles {
  AppTextStyles._();

  // --- Montserrat: основной шрифт ---

  static TextStyle get displayLarge => const TextStyle(
        fontFamily: 'Bebas Neue',
        fontSize: 40,
        height: 1.1,
        letterSpacing: 0.5,
        color: BrandColors.graphite,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: BrandColors.graphite,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: BrandColors.graphite,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: BrandColors.graphite,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: BrandColors.graphite,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: BrandColors.graphite,
      );

  /// Основной наборный текст.
  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: BrandColors.graphite,
      );

  /// Подписи/метки/меню.
  static TextStyle get bodySmall => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: BrandColors.grayDark,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: BrandColors.grayDark,
      );

  /// Контролы-ссылки, подписи действий, бейджи.
  /// Промежуточный шаг между [bodyMedium] (14) и [titleMedium] (16):
  /// возвращает в шкалу ранее «плавающий» размер 15.
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: BrandColors.graphite,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: BrandColors.grayMid,
      );

  /// Кнопка (Montserrat SemiBold).
  static TextStyle get button => const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: BrandColors.white,
      );
}
