import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../domain/project.dart';

/// Helpers visuais para [Project] — mapa de cores da barra de progresso,
/// variantes de badge para status, ícones de links externos.
class ProjectVisuals {
  ProjectVisuals._();

  /// Cor da barra de progresso conforme [color].
  static Color progressColor(ProjectColor color) => switch (color) {
        ProjectColor.green  => AppColors.accent,
        ProjectColor.blue   => AppColors.blue,
        ProjectColor.amber  => AppColors.amber,
        ProjectColor.purple => AppColors.purple,
        ProjectColor.pink   => AppColors.pink,
        ProjectColor.red    => AppColors.red,
      };

  /// Variante de [AppBadge] e label legível para um [ProjectStatus].
  static (BadgeVariant, String) badge(ProjectStatus status) =>
      switch (status) {
        ProjectStatus.planning  => (BadgeVariant.idea, 'Em ideação'),
        ProjectStatus.active    => (BadgeVariant.dev, 'Em desenvolvimento'),
        ProjectStatus.onHold    => (BadgeVariant.pause, 'Pausado'),
        ProjectStatus.completed => (BadgeVariant.done, 'Finalizado'),
        ProjectStatus.archived  => (BadgeVariant.member, 'Arquivado'),
      };
}

/// Identificação visual de um link externo (ícone de 2 letras + cor).
///
/// Detecta o domínio do link e retorna um label curto + paleta. Fallback
/// para "WW" cinza quando não reconhece.
class LinkIconInfo {
  const LinkIconInfo({
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String label;
  final Color bg;
  final Color fg;

  /// Detecta o tipo de link a partir da URL.
  static LinkIconInfo forUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('github.com')) {
      return const LinkIconInfo(
        label: 'GH',
        bg: AppColors.blueDim,
        fg: AppColors.blueText,
      );
    }
    if (lower.contains('gitlab')) {
      return const LinkIconInfo(
        label: 'GL',
        bg: AppColors.amberDim,
        fg: AppColors.amberText,
      );
    }
    if (lower.contains('drive.google') ||
        lower.contains('docs.google') ||
        lower.contains('sheets.google')) {
      return const LinkIconInfo(
        label: 'DR',
        bg: AppColors.amberDim,
        fg: AppColors.amberText,
      );
    }
    if (lower.contains('figma.com')) {
      return const LinkIconInfo(
        label: 'FG',
        bg: AppColors.accentDim,
        fg: AppColors.accentText,
      );
    }
    if (lower.contains('trello.com')) {
      return const LinkIconInfo(
        label: 'TR',
        bg: AppColors.pinkDim,
        fg: AppColors.pinkText,
      );
    }
    if (lower.contains('notion.so')) {
      return const LinkIconInfo(
        label: 'NT',
        bg: AppColors.grayDim,
        fg: AppColors.txtPrimary,
      );
    }
    if (lower.contains('slack.com')) {
      return const LinkIconInfo(
        label: 'SL',
        bg: AppColors.purpleDim,
        fg: AppColors.purpleText,
      );
    }
    if (lower.contains('discord')) {
      return const LinkIconInfo(
        label: 'DC',
        bg: AppColors.purpleDim,
        fg: AppColors.purpleText,
      );
    }
    if (lower.contains('youtube.com') || lower.contains('youtu.be')) {
      return const LinkIconInfo(
        label: 'YT',
        bg: AppColors.redDim,
        fg: AppColors.redText,
      );
    }
    return const LinkIconInfo(
      label: 'WW',
      bg: AppColors.grayDim,
      fg: AppColors.grayText,
    );
  }
}

/// Versão amigável e curta de uma URL (sem `https://`, sem `www.`, máx. ~32 chars).
String prettyUrl(String url) {
  var clean = url.trim();
  clean = clean.replaceFirst(RegExp(r'^https?://'), '');
  clean = clean.replaceFirst(RegExp(r'^www\.'), '');
  if (clean.endsWith('/')) clean = clean.substring(0, clean.length - 1);
  if (clean.length > 40) clean = '${clean.substring(0, 37)}...';
  return clean;
}
