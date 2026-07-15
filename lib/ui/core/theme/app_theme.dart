import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_text_styles.dart';
import 'brand_colors.dart';
import 'brand_radius.dart';

/// Светлая тема приложения по брендбуку «Умная Логистика».
ThemeData appTheme() {
  const colorScheme = ColorScheme.light(
    primary: BrandColors.primary,
    onPrimary: BrandColors.white,
    secondary: BrandColors.blue,
    onSecondary: BrandColors.white,
    error: BrandColors.error,
    onError: BrandColors.white,
    surface: BrandColors.white,
    onSurface: BrandColors.graphite,
    surfaceContainerHighest: BrandColors.grayLighter,
    outline: BrandColors.grayLight,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BrandColors.paperWarm,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  return base.copyWith(
    textTheme: GoogleFonts.montserratTextTheme(base.textTheme).copyWith(
      displayLarge: AppTextStyles.displayLarge,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.labelMedium,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: BrandColors.white,
      foregroundColor: BrandColors.graphite,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.primary,
        foregroundColor: BrandColors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0,
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BrandRadius.md),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: BrandColors.primary,
        textStyle: AppTextStyles.titleMedium.copyWith(fontSize: 15),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BrandColors.graphite,
        minimumSize: const Size.fromHeight(52),
        textStyle: AppTextStyles.button.copyWith(color: BrandColors.graphite),
        side: const BorderSide(color: BrandColors.grayLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BrandRadius.md),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BrandColors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayMid),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayMid),
      errorStyle: AppTextStyles.caption.copyWith(color: BrandColors.error),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
        borderSide: const BorderSide(color: BrandColors.grayLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
        borderSide: const BorderSide(color: BrandColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
        borderSide: const BorderSide(color: BrandColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
        borderSide: const BorderSide(color: BrandColors.error, width: 1.5),
      ),
    ),
    cardTheme: CardTheme(
      color: BrandColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: BrandColors.grayLighter,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: BrandColors.white,
      selectedItemColor: BrandColors.primary,
      unselectedItemColor: BrandColors.grayMid,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: BrandColors.primary,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: BrandColors.graphite,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: BrandColors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BrandRadius.sm),
      ),
    ),
  );
}
