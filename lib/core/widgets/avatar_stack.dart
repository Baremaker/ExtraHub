import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'app_avatar.dart';

/// Empilhador de avatares (avatares circulares parcialmente sobrepostos).
///
/// Mostra até [maxVisible] avatares e, se houver mais, agrega o resto em
/// um avatar cinza com "+N".
///
/// Cada [AvatarSpec] tem `initials` e (opcional) `seed` para escolher
/// cor determinística.
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.specs,
    this.maxVisible = 3,
    this.size = AvatarSize.xs,
    this.overlap = 8,
  });

  final List<AvatarSpec> specs;
  final int maxVisible;
  final AvatarSize size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final visible = specs.take(maxVisible).toList(growable: false);
    final extra = specs.length - visible.length;
    final effectiveSize = size.size;
    final width = visible.isEmpty
        ? 0.0
        : effectiveSize +
            (visible.length - 1) * (effectiveSize - overlap) +
            (extra > 0 ? (effectiveSize - overlap) : 0);

    return SizedBox(
      width: width,
      height: effectiveSize,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (effectiveSize - overlap),
              child: _BorderedAvatar(
                child: AppAvatar(
                  initials: visible[i].initials,
                  size: size,
                  seed: visible[i].seed,
                ),
              ),
            ),
          if (extra > 0)
            Positioned(
              left: visible.length * (effectiveSize - overlap),
              child: _BorderedAvatar(
                child: AppAvatar(
                  initials: '+$extra',
                  size: size,
                  palette: AvatarPalette.gray,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BorderedAvatar extends StatelessWidget {
  const _BorderedAvatar({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.bgCard, width: 2),
      ),
      child: child,
    );
  }
}

class AvatarSpec {
  const AvatarSpec({required this.initials, this.seed});
  final String initials;
  final String? seed;
}
