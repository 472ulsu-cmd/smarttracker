import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_colors.dart';

/// Типографика приложения по брендбуку.
///
/// Основной шрифт — **Montserrat** (Regular/Medium/SemiBold/Bold).
/// Акцентный шрифт для крупных заголовков — **Bebas Neue** (Regular).
class AppTextStyles {
  AppTextStyles._();

  // --- Montserrat: основной шрифт ---

  static TextStyle get displayLarge => GoogleFonts.bebasNeue(
        fontSize: 40,
        height: 1.1,
        letterSpacing: 0.5,
        color: BrandColors.graphite,
      );

  static TextStyle get headlineLarge => GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: BrandColors.graphite,
      );

  static TextStyle get headlineMedium => GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: BrandColors.graphite,
      );

  static TextStyle get titleLarge => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: BrandColors.graphite,
      );

  static TextStyle get titleMedium => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: BrandColors.graphite,
      );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: BrandColors.graphite,
      );

  /// Основной наборный текст.
  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: BrandColors.graphite,
      );

  /// Подписи/метки/меню.
  static TextStyle get bodySmall => GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: BrandColors.grayDark,
      );

  static TextStyle get labelMedium => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: BrandColors.grayDark,
      );

  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: BrandColors.grayMid,
      );

  /// Кнопка (Montserrat SemiBold).
  static TextStyle get button => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: BrandColors.white,
      );
}
