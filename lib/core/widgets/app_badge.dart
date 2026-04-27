import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Variante de cor para [AppBadge]. Espelha as classes `.badge-*` do
/// protótipo HTML (super, admin, membro, dev, idea, pause, done, gray).
enum BadgeVariant {
  /// Verde claro — Owner / "Super Admin" no protótipo.
  owner(AppColors.accentDim, AppColors.accentText),

  /// Roxo — Admin.
  admin(AppColors.purpleDim, AppColors.purpleText),

  /// Cinza — Membro.
  member(AppColors.grayDim, AppColors.grayText),

  /// Azul — Em desenvolvimento.
  dev(AppColors.blueDim, AppColors.blueText),

  /// Âmbar — Em ideação / planejamento.
  idea(AppColors.amberDim, AppColors.amberText),

  /// Cinza-vermelho — Pausado.
  pause(AppColors.grayDim, AppColors.redText),

  /// Verde — Concluído / Finalizado.
  done(AppColors.accentDim, AppColors.accentText),

  /// Vermelho — Inativo / Ex-membro / Erro.
  inactive(AppColors.redDim, AppColors.redText),

  /// Rosa — destaque alternativo.
  highlight(AppColors.pinkDim, AppColors.pinkText);

  const BadgeVariant(this.bg, this.fg);
  final Color bg;
  final Color fg;
}

/// Badge pequeno arredondado com texto curto.
///
/// Uso típico: `AppBadge(label: 'Admin', variant: BadgeVariant.admin)`.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.member,
    this.icon,
  });

  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: variant.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: variant.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: variant.fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
