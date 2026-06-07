import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Tema unificado do ExtraHub.
///
/// Junta cores, tipografia e radii em um `ThemeData` consumível por
/// `MaterialApp.theme`. O app é dark-only (espelhando o protótipo); se um dia
/// quisermos tema claro, criamos um `lightTheme()` aqui também.
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
      surface: AppColors.bgCard,
      onSurface: AppColors.txtPrimary,
      primary: AppColors.accent,
      onPrimary: Colors.white,
      error: AppColors.red,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgBase,
      canvasColor: AppColors.bgBase,
      textTheme: AppTypography.textTheme,

      // ─── BOTÕES ──────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentStrong,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          textStyle: AppTypography.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentText,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusSm),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.txtPrimary,
          side: const BorderSide(color: AppColors.borderMd),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
        ),
      ),

      // ─── INPUTS ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInput,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: const OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.radiusMd,
          borderSide: BorderSide(color: AppColors.red),
        ),
        labelStyle: AppTypography.textTheme.bodySmall,
        hintStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.txtTertiary,
        ),
      ),

      // ─── CARDS ───────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: AppColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusLg,
          side: BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // ─── DIVIDER ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ─── APPBAR (vamos usar pouco; o app é majoritariamente sidebar+topbar customizada) ──
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgCard,
        foregroundColor: AppColors.txtPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.headlineMedium,
      ),

      // ─── SNACKBAR ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgHover,
        contentTextStyle: AppTypography.textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
      ),

      // ─── DIALOG ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        titleTextStyle: AppTypography.textTheme.headlineLarge,
        contentTextStyle: AppTypography.textTheme.bodyMedium,
      ),
    );
  }
}
