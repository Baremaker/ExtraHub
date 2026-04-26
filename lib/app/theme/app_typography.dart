import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tipografia do ExtraHub.
///
/// Usamos **Inter** (via `google_fonts`) porque é o que mais se aproxima do
/// `system-ui` que o protótipo HTML especifica, com a vantagem de ser
/// consistente entre Android, iOS e web.
///
/// Os nomes dos estilos seguem a convenção do Material 3 (`headlineLarge`,
/// `bodyMedium`, etc.) para que o `Theme.of(context).textTheme` funcione
/// naturalmente, mas os valores foram calibrados a partir dos `font-size`
/// observados no protótipo.
class AppTypography {
  AppTypography._();

  static TextTheme textTheme = TextTheme(
    // ─── HEADLINES (títulos de página) ────────────────────────────────────
    displayLarge: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.txtPrimary,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.txtPrimary,
      height: 1.25,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.txtPrimary,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.txtPrimary,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.txtPrimary,
      height: 1.4,
    ),

    // ─── BODY (texto corrido) ─────────────────────────────────────────────
    bodyLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.txtPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.txtPrimary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.txtSecondary,
      height: 1.5,
    ),

    // ─── LABELS (botões, badges, captions) ────────────────────────────────
    labelLarge: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.txtPrimary,
      height: 1.3,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.txtSecondary,
      height: 1.3,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.txtTertiary,
      letterSpacing: 0.7,
      height: 1.3,
    ),
  );

  /// Estilo das nav-section labels da sidebar (uppercase com letter-spacing).
  static TextStyle navSection = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.txtTertiary,
    letterSpacing: 0.7,
  );

  /// Estilo das badges (cor é aplicada no widget).
  static TextStyle badge = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
}
