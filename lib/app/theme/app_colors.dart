import 'package:flutter/material.dart';

/// Paleta de cores do ExtraHub.
///
/// Espelha 1:1 as variáveis CSS do protótipo HTML
/// (`extrahub_prototipo.html` → `:root { --bg-base: ... }`).
/// Quando uma cor mudar no design, atualiza-se aqui e o app inteiro acompanha.
///
/// Categorias:
///   * `bg*`     → fundos (base, cards, hover, inputs)
///   * `border*` → bordas
///   * `accent*` → cor primária da marca (verde)
///   * `red/blue/amber/purple/pink/gray` → cores semânticas para badges,
///     status e categorias de projeto
///   * `txt*`    → textos
class AppColors {
  AppColors._();

  // ─── FUNDOS ────────────────────────────────────────────────────────────────
  static const Color bgBase  = Color(0xFF0D1117); // --bg-base
  static const Color bgCard  = Color(0xFF161B27); // --bg-card
  static const Color bgHover = Color(0xFF1E2535); // --bg-hover
  static const Color bgInput = Color(0xFF1A2030); // --bg-input

  // ─── BORDAS ────────────────────────────────────────────────────────────────
  static const Color border   = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color borderMd = Color(0x21FFFFFF); // rgba(255,255,255,0.13)

  // ─── ACCENT (verde — cor primária da marca) ───────────────────────────────
  static const Color accent     = Color(0xFF1D9E75); // --accent
  static const Color accentDim  = Color(0xFF0A2A1E); // --accent-dim
  static const Color accentText = Color(0xFF5DCAA5); // --accent-text
  static const Color accentLite = Color(0xFF9FE1CB); // --accent-lite
  // Verde mais escuro só para o FUNDO de botões com texto branco: garante
  // contraste WCAG AA (4.9:1) que o `accent` puro não atinge (3.4:1).
  static const Color accentStrong = Color(0xFF158055);

  // ─── VERMELHO ──────────────────────────────────────────────────────────────
  static const Color red     = Color(0xFFE24B4A);
  static const Color redDim  = Color(0xFF2A0F0F);
  static const Color redText = Color(0xFFF87171);

  // ─── AZUL ──────────────────────────────────────────────────────────────────
  static const Color blue     = Color(0xFF378ADD);
  static const Color blueDim  = Color(0xFF0D1F35);
  static const Color blueText = Color(0xFF7FB8F0);

  // ─── ÂMBAR ─────────────────────────────────────────────────────────────────
  static const Color amber     = Color(0xFFEF9F27);
  static const Color amberDim  = Color(0xFF2A1A05);
  static const Color amberText = Color(0xFFF6C76B);

  // ─── ROXO ──────────────────────────────────────────────────────────────────
  static const Color purple     = Color(0xFF7F77DD);
  static const Color purpleDim  = Color(0xFF1A1830);
  static const Color purpleText = Color(0xFFB0AAEE);

  // ─── ROSA ──────────────────────────────────────────────────────────────────
  static const Color pink     = Color(0xFFD4537E);
  static const Color pinkDim  = Color(0xFF2A0E1C);
  static const Color pinkText = Color(0xFFF09AB5);

  // ─── CINZA NEUTRO ──────────────────────────────────────────────────────────
  static const Color grayDim  = Color(0xFF1E2230);
  static const Color grayText = Color(0xFF8892A4);

  // ─── TEXTO ─────────────────────────────────────────────────────────────────
  static const Color txtPrimary   = Color(0xFFE8EAF0);
  static const Color txtSecondary = Color(0xFF8892A4);
  // Clareado de #4A5568 para passar WCAG AA (5.1:1 sobre o fundo base).
  static const Color txtTertiary  = Color(0xFF7A8699);
}
