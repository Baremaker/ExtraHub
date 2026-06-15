import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Tamanhos de avatar. Espelham as classes `.av-22 / .av-28 / .av-32 / .av-44 / .av-64`
/// do protótipo HTML.
enum AvatarSize {
  xs(22, 9),
  sm(28, 10),
  md(32, 12),
  lg(44, 15),
  xl(64, 22);

  const AvatarSize(this.size, this.fontSize);
  final double size;
  final double fontSize;
}

/// Paletas de avatar (background + texto). Espelham `.av-g/.av-b/.av-a/.av-p/.av-pk`.
enum AvatarPalette {
  green(AppColors.accentDim, AppColors.accentText),
  blue(AppColors.blueDim, AppColors.blueText),
  amber(AppColors.amberDim, AppColors.amberText),
  purple(AppColors.purpleDim, AppColors.purpleText),
  pink(AppColors.pinkDim, AppColors.pinkText),
  gray(AppColors.grayDim, AppColors.grayText);

  const AvatarPalette(this.bg, this.fg);
  final Color bg;
  final Color fg;

  /// Escolhe uma paleta determinística baseada no [seed]. Útil para que o
  /// avatar do usuário "Felipe" sempre tenha a mesma cor.
  static AvatarPalette forSeed(String seed) {
    final palettes = AvatarPalette.values
        .where((p) => p != AvatarPalette.gray)
        .toList(growable: false);
    final idx = seed.hashCode.abs() % palettes.length;
    return palettes[idx];
  }
}

/// Avatar circular com inicial(is) sobre uma cor de fundo determinística.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.initials,
    this.size = AvatarSize.md,
    this.palette,
    this.seed,
  });

  /// Iniciais a exibir (ex: "FM"). Recomenda-se 1-2 caracteres.
  final String initials;
  final AvatarSize size;

  /// Cor explícita. Se nulo, deriva de [seed]. Se ambos nulos, usa cinza.
  final AvatarPalette? palette;

  /// String usada para escolher cor determinística (geralmente o uid ou o nome).
  final String? seed;

  @override
  Widget build(BuildContext context) {
    final p = palette ??
        (seed != null ? AvatarPalette.forSeed(seed!) : AvatarPalette.gray);

    return Container(
      width: size.size,
      height: size.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: p.bg,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          color: p.fg,
          fontSize: size.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
